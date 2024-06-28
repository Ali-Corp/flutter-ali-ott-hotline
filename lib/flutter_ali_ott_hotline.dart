import 'package:flutter/foundation.dart';
import 'package:flutter_ali_ott_hotline/src/entities/ALIOTTHotlineConfig.dart';
import 'package:flutter_ali_ott_hotline/src/entities/IOSCallKit.dart';

import 'flutter_ali_ott_hotline_platform_interface.dart';

export 'src/entities/ALIOTTCall.dart';
export 'src/entities/ALIOTTCallState.dart';
export 'src/entities/ALIOTTHotlineConfig.dart';
export 'src/entities/IOSCallKit.dart';

class FlutterAliOttHotline {
  void config(String environment, ALIOTTHotlineConfig hotlineConfig,
      {IOSCallKit? iOSCallKit,
      String? customOnHoldSound,
      double? timeoutForOutgoingCall}) async {
    return FlutterAliOttHotlinePlatform.instance.config(
        environment, hotlineConfig,
        iOSCallKit: iOSCallKit,
        customOnHoldSound: customOnHoldSound,
        timeoutForOutgoingCall: timeoutForOutgoingCall);
  }

  void startHotlineCall(
    String callerId,
    String callerName,
    String? callerAvatar,
  ) async {
    return FlutterAliOttHotlinePlatform.instance
        .startHotlineCall(callerId, callerName, callerAvatar);
  }

  void startListenEvent() async {
    return FlutterAliOttHotlinePlatform.instance.startListenEvent();
  }

  void stopListenEvent() async {
    return FlutterAliOttHotlinePlatform.instance.stopListenEvent();
  }

  void startListenCallEvent() async {
    return FlutterAliOttHotlinePlatform.instance.startListenCallEvent();
  }

  void stopListenCallEvent() async {
    return FlutterAliOttHotlinePlatform.instance.stopListenCallEvent();
  }

  void endCall() async {
    return FlutterAliOttHotlinePlatform.instance.endCall();
  }

  void setSpeakOn(
    bool isOn,
  ) async {
    return FlutterAliOttHotlinePlatform.instance.setSpeakOn(isOn);
  }

  void setMuteCall(
    bool isOn,
  ) async {
    return FlutterAliOttHotlinePlatform.instance.setMuteCall(isOn);
  }

  void setEventCallbacks({
    VoidCallback? onInitSuccess,
    VoidCallback? onInitFail,
    RequestShowCallCallback? onRequestShowCall,
  }) async {
    return FlutterAliOttHotlinePlatform.instance.setEventCallbacks(
        onInitSuccess: onInitSuccess,
        onInitFail: onInitFail,
        onRequestShowCall: onRequestShowCall);
  }

  void setCallEventCallbacks({
    CallStateChangeCallback? onCallStateChange,
    CallConnectedChangeCallback? onCallConnectedChange,
  }) async {
    return FlutterAliOttHotlinePlatform.instance.setCallEventCallbacks(
        onCallStateChange: onCallStateChange,
        onCallConnectedChange: onCallConnectedChange);
  }
}
