import 'package:flutter/services.dart';
import 'package:flutter_ali_ott_hotline/flutter_ali_ott_hotline.dart';
import 'package:flutter_ali_ott_hotline/src/entities/ALIOTTHotlineConfig.dart';
import 'package:flutter_ali_ott_hotline/src/entities/IOSCallKit.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ali_ott_hotline_method_channel.dart';

typedef UpdatePushKitTokenCallback = void Function(String pushToken);
typedef NotifyCallCallback = void Function(String alert);
typedef RequestShowCallCallback = void Function(ALIOTTCall call);

typedef CallStateChangeCallback = void Function(ALIOTTCallState callState);
typedef CallConnectedChangeCallback = void Function(
  ALIOTTCallConnectedState connectedState,
  DateTime? connectedDate,
);

abstract class FlutterAliOttHotlinePlatform extends PlatformInterface {
  /// Constructs a FlutterAliOttHotlinePlatform.
  FlutterAliOttHotlinePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAliOttHotlinePlatform _instance =
      MethodChannelFlutterAliOttHotline();

  /// The default instance of [FlutterAliOttHotlinePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAliOttHotline].
  static FlutterAliOttHotlinePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAliOttHotlinePlatform] when
  /// they register themselves.
  static set instance(FlutterAliOttHotlinePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void config(String environment, ALIOTTHotlineConfig hotlineConfig,
      {IOSCallKit? iOSCallKit,
      String? customOnHoldSound,
      double? timeoutForOutgoingCall}) {
    throw UnimplementedError('config() has not been implemented.');
  }

  void startHotlineCall(
    String callerId,
    String callerName,
    String? callerAvatar,
  ) {
    throw UnimplementedError('startHotlineCall() has not been implemented.');
  }

  void startListenEvent() {
    throw UnimplementedError('startListenEvent() has not been implemented.');
  }

  void stopListenEvent() {
    throw UnimplementedError('stopListenEvent() has not been implemented.');
  }

  void startListenCallEvent() {
    throw UnimplementedError(
        'startListenCallEvent() has not been implemented.');
  }

  void stopListenCallEvent() {
    throw UnimplementedError('stopListenCallEvent() has not been implemented.');
  }

  void endCall() async {
    throw UnimplementedError('endCall() has not been implemented.');
  }

  void setSpeakOn(
    bool isOn,
  ) {
    throw UnimplementedError('setSpeakOn() has not been implemented.');
  }

  void setMuteCall(
    bool isOn,
  ) {
    throw UnimplementedError('setMuteCall() has not been implemented.');
  }

  void setEventCallbacks({
    VoidCallback? onInitSuccess,
    VoidCallback? onInitFail,
    RequestShowCallCallback? onRequestShowCall,
  }) {
    throw UnimplementedError('setEventCallbacks() has not been implemented.');
  }

  void setCallEventCallbacks({
    CallStateChangeCallback? onCallStateChange,
    CallConnectedChangeCallback? onCallConnectedChange,
  }) {
    throw UnimplementedError(
        'setCallEventCallbacks() has not been implemented.');
  }
}
