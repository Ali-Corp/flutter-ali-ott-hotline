import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'status_widget.dart';
import 'package:flutter_ali_ott_hotline/flutter_ali_ott_hotline.dart';

class CallingPage extends StatefulWidget {
  final FlutterAliOttHotline plugin;
  final ALIOTTCall call;
  final VoidCallback onEndCall;
  const CallingPage(this.plugin, this.call, this.onEndCall, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CallingPageState();
  }
}

class CallingPageState extends State<CallingPage> {
  ALIOTTCall get call => widget.call;

  var avatar = "";
  var calleeName = "";
  ALIOTTCallState callState = ALIOTTCallState.ALIOTTCallStatePending;
  ALIOTTCallConnectedState callConnectedState =
      ALIOTTCallConnectedState.ALIOTTConnectedStatePending;
  DateTime? connectedTime;
  bool _isDismissed = false;
  bool mute = false;
  bool speaker = false;

  @override
  void initState() {
    super.initState();

    widget.plugin.setCallEventCallbacks(
      onCallStateChange: (state) {
        if (mounted) {
          setState(() {
            handleStageCall(state);
          });
        }
      },
      onCallConnectedChange: (connectedState, connectedDate) => {
        if (mounted)
          {
            setState(() {
              callConnectedState = connectedState;
              connectedTime = connectedDate;
              if (callConnectedState ==
                      ALIOTTCallConnectedState.ALIOTTConnectedStateComplete &&
                  connectedTime != null) {
                handleStageCall(ALIOTTCallState.ALIOTTCallStateActive);
              }
            })
          }
      },
    );

    handleDataUI();
  }

  void handleStageCall(state) {
    callState = state;
    print("handleStageCall $state");
    if (state == ALIOTTCallState.ALIOTTCallStateEnded && !_isDismissed) {
      if (mounted) {
        setState(() {
          _isDismissed = true;
        });
      }

      widget.onEndCall();
    }
    if (state == ALIOTTCallState.ALIOTTCallStateEnded) {}
  }

  void handleDataUI() {
    avatar = call.calleeAvatar;
    calleeName = call.calleeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 100),
              ),
              CachedNetworkImage(
                imageUrl: avatar,
                imageBuilder: (context, imageProvider) => Container(
                  //color: Colors.blue,
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/avatar.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              Text(
                calleeName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              CallStatusView(
                callState: callState,
                connectedTime: connectedTime,
              ),
              Expanded(child: Container()),
              // nút mute, speaker
              wigetSpeakerMuteButtion(context),
              // nút gọi
              wigetCallButton(context),

              Container(
                padding: const EdgeInsets.only(bottom: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  wigetSpeakerMuteButtion(BuildContext context) {
    print(
        "wigetSpeakerMuteButtion  $callState $callConnectedState $connectedTime");
    if (callState == ALIOTTCallState.ALIOTTCallStateActive &&
        callConnectedState ==
            ALIOTTCallConnectedState.ALIOTTConnectedStateComplete &&
        connectedTime != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Ink(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: const AssetImage('assets/icons/ic_mute@3x.png'),
                        colorFilter: ColorFilter.mode(
                          mute ? Colors.white : Colors.white24,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    toggleMute();
                  }, // Handle your callback.
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'mute',
                    style: mute
                        ? const TextStyle(fontSize: 16, color: Colors.white)
                        : const TextStyle(fontSize: 16, color: Colors.white24),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Ink(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image:
                            const AssetImage('assets/icons/ic_speaker@3x.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          speaker ? Colors.white : Colors.white24,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    toggleSpeaker();
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'speaker',
                    style: speaker
                        ? const TextStyle(fontSize: 16, color: Colors.white)
                        : const TextStyle(fontSize: 16, color: Colors.white24),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  wigetCallButton(BuildContext context) {
    if (callState == ALIOTTCallState.ALIOTTCallStatePending) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Ink(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/ic_call_end@3x.png',
                    height: 40, // Set the height of the image
                    width: 40, // Set the width of the image
                  ),
                ),
              ),
              onTap: () {
                endCall();
              },
            ),
          ],
        ),
      );
    } else if (callState == ALIOTTCallState.ALIOTTCallStateActive) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Ink(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/ic_call_end@3x.png',
                    height: 40, // Set the height of the image
                    width: 40, // Set the width of the image
                  ),
                ),
              ),
              onTap: () {
                endCall();
              },
            ),
          ],
        ),
      );
    }
    return Container();
  }

  toggleMute() async {
    if (mounted) {
      setState(() {
        mute = !mute;
        widget.plugin.setMuteCall(mute);
      });
    }
  }

  toggleSpeaker() async {
    if (mounted) {
      setState(() {
        speaker = !speaker;
        widget.plugin.setSpeakOn(speaker);
      });
    }
  }

  endCall() async {
    if (mounted) {
      setState(() {
        callState = ALIOTTCallState.ALIOTTCallStateEnded;
      });

      widget.plugin.endCall();
      widget.onEndCall();
    }
  }

  @override
  void dispose() {
    super.dispose();

    // if (calling != null) FlutterCallkitIncoming.endCall(calling!.id!);
  }
}
