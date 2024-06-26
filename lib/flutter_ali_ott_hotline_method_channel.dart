import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ali_ott_hotline/flutter_ali_ott_hotline.dart';
import 'package:flutter_ali_ott_hotline/src/service_notification.dart';

import 'flutter_ali_ott_hotline_platform_interface.dart';

/// An implementation of [FlutterAliOttHotlinePlatform] that uses method channels.
class MethodChannelFlutterAliOttHotline extends FlutterAliOttHotlinePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ali_ott_hotline');
  final eventChannel = const EventChannel('flutter_ali_ott_hotline_event');

  final notificationService = ALIOTTNotificationService.instance;

  VoidCallback? onInitSuccess;
  VoidCallback? onInitFail;
  RequestShowCallCallback? onRequestShowCall;

  CallStateChangeCallback? onCallStateChange;
  CallConnectedChangeCallback? onCallConnectedChange;

  StreamSubscription<dynamic>? _eventSubscription;

  Function(dynamic)? _onEvent;

  @override
  void config(String environment, ALIOTTHotlineConfig hotlineConfig,
      {IOSCallKit? iOSCallKit,
      String? customOnHoldSound,
      double? timeoutForOutgoingCall}) async {
    await methodChannel.invokeMethod(
      'config',
      {
        'environment': environment,
        'hotlineConfig': hotlineConfig.toJson(),
        'iOSCallKit': iOSCallKit,
        'customOnHoldSound': customOnHoldSound,
        'timeoutForOutgoingCall': timeoutForOutgoingCall,
      },
    );
  }

  @override
  void startHotlineCall(
    String callerId,
    String callerName,
    String? callerAvatar,
  ) async {
    await methodChannel.invokeMethod(
      'startHotlineCall',
      {
        'callerId': callerId,
        'callerName': callerName,
        'callerAvatar': callerAvatar,
      },
    );
  }

  @override
  Future<void> startListenEvent() async {
    await methodChannel.invokeMethod(
      'startListenEvent',
    );
    _onEvent = (event) async {
      final eventMap = Map<String, dynamic>.from(event);
      debugPrint('Event: $eventMap');

      final type = eventMap['type'] as String;
      final payload = Map<String, dynamic>.from(
          eventMap.containsKey("payload") ? eventMap['payload'] : {});

      switch (type) {
        case 'aliottOnInitSuccess':
          onInitSuccess?.call();
          break;
        case 'aliottOnInitFail':
          onInitFail?.call();
          break;
        case 'aliottOnRequestShowCall':
          onRequestShowCall?.call(ALIOTTCall.fromJson(
              Map<String, dynamic>.from(eventMap['payload'])));
          break;
        case 'aliottOnCallStateChange':
          final callState =
              ALIOTTCallStateExtension.fromString(payload['callState']);
          // if (Platform.isAndroid) {
          //   notificationService.onstreamCallState.sink.add(callState);
          // }

          onCallStateChange?.call(callState);
          break;
        case 'aliottOnCallConnectedChange':
          final connectedState = ALIOTTCallConnectedStateExtension.fromString(
              payload['connectedState']);
          late DateTime? connectedDate;
          if (payload.containsKey('connectedDate')) {
            final unixTimestamp = payload['connectedDate'] as int;
            connectedDate = DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
          }
          //final connectedDate = DateTime.parse(args['connectedDate']);
          onCallConnectedChange?.call(
            connectedState,
            connectedDate,
          );
          break;
        default:
          break;
      }
    };
    _eventSubscription = eventChannel.receiveBroadcastStream().listen(_onEvent);
  }

  @override
  void stopListenEvent() {
    methodChannel.invokeMethod(
      'stopListenEvent',
    );
    _eventSubscription?.cancel();
  }

  @override
  void startListenCallEvent() {
    methodChannel.invokeMethod(
      'startListenCallEvent',
    );
  }

  @override
  void stopListenCallEvent() {
    methodChannel.invokeMethod(
      'stopListenCallEvent',
    );
  }

  @override
  void endCall() {
    methodChannel.invokeMethod(
      'endCall',
    );
  }

  @override
  void setSpeakOn(
    bool isOn,
  ) async {
    await methodChannel.invokeMethod(
      'setSpeakOn',
      {
        'on': isOn,
      },
    );
  }

  @override
  void setMuteCall(
    bool isOn,
  ) {
    methodChannel.invokeMethod(
      'setMuteCall',
      {
        'on': isOn,
      },
    );
  }

  @override
  void setEventCallbacks({
    VoidCallback? onInitSuccess,
    VoidCallback? onInitFail,
    RequestShowCallCallback? onRequestShowCall,
  }) {
    this.onInitSuccess = onInitSuccess;
    this.onInitFail = onInitFail;
    this.onRequestShowCall = onRequestShowCall;
  }

  @override
  void setCallEventCallbacks({
    CallStateChangeCallback? onCallStateChange,
    CallConnectedChangeCallback? onCallConnectedChange,
  }) {
    this.onCallStateChange = onCallStateChange;
    this.onCallConnectedChange = onCallConnectedChange;

    if (onCallStateChange == null || onCallConnectedChange == null) {
      stopListenCallEvent();
      return;
    }

    startListenCallEvent();
  }
}
