import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ali_ott_hotline/src/entities/ALIOTTCallState.dart';

class CallStatusView extends StatefulWidget {
  ALIOTTCallState callState;
  DateTime? connectedTime;

  CallStatusView({
    Key? key,
    required this.callState,
    required this.connectedTime,
  }) : super(key: key);

  @override
  _CallStatusViewState createState() => _CallStatusViewState();
}

class _CallStatusViewState extends State<CallStatusView> {
  ALIOTTCallState? get callState => widget.callState;
  DateTime? get connectedTime => widget.connectedTime;
  Timer? _timer;
  int _start = 0;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          setState(() {
            if (connectedTime != null) {
              _start = DateTime.now().difference(connectedTime!).inSeconds;
            }
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (callState == ALIOTTCallState.ALIOTTCallStateEnded) {
      return Container(
        padding: const EdgeInsets.only(top: 4),
        child: const Text(
          'Kết thúc',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    } else if (callState == ALIOTTCallState.ALIOTTCallStatePending ||
        callState == ALIOTTCallState.ALIOTTCallStateCalling) {
      return Container(
        padding: const EdgeInsets.only(top: 4),
        child: const Text(
          'Đang gọi ...',
          style: TextStyle(color: Colors.green, fontSize: 16),
        ),
      );
    } else if (callState == ALIOTTCallState.ALIOTTCallStateActive) {
      if (connectedTime != null) {
        //final time = DateTime.now().difference(connectedTime!).inSeconds;
        return Container(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${(_start / 60).floor().toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.green, fontSize: 16),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          child: const Text(
            'Đang gọi ...',
            style: TextStyle(color: Colors.green, fontSize: 16),
          ),
        );
      }
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 4),
        child: const Text(
          'Đang gọi...',
          style: TextStyle(color: Colors.green, fontSize: 16),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
