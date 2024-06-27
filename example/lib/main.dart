import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ali_ott_hotline/flutter_ali_ott_hotline.dart';
import 'package:flutter_ali_ott_hotline_example/call_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ALIOTTCall? _call;
  final _flutterAliOttHotlinePlugin = FlutterAliOttHotline();
  final phoneApp = '0123123123';
  final fullName = 'Guest Demo';
  final avatarGuest =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl9iEvsQTiAV0n55hDtyEFRAmDNomSPd7Xq68dqBgX57Fp8W5qgTvaFRT2mg&s';
  //Tham số host line
  final REPLACE_SERVICE_ID = '1';
  final REPLACE_SERVICE_KEY = '1%40B6A7A0357758CD9F';
  final REPLACE_SERVICE_NAME = 'Hotline Taxi';
  final REPLACE_SERVICE_AVATAR =
      'https://images.unsplash.com/photo-1574328495409-33bc8aff6d56?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  @override
  void initState() {
    super.initState();

    _flutterAliOttHotlinePlugin.startListenEvent();
    _flutterAliOttHotlinePlugin.setEventCallbacks(
        onInitSuccess: () => {debugPrint("Init success")},
        onInitFail: () => {debugPrint("Init fail")},
        onRequestShowCall: (ALIOTTCall call) => {
              setState(() {
                _call = call;
              })
            });
    _flutterAliOttHotlinePlugin.config(
      "production",
      ALIOTTHotlineConfig(
        id: REPLACE_SERVICE_ID,
        key: REPLACE_SERVICE_KEY,
        name: REPLACE_SERVICE_NAME,
        icon: REPLACE_SERVICE_AVATAR,
      ),
    );
  }

  @override
  void dispose() {
    _flutterAliOttHotlinePlugin.stopListenEvent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: TextButton(
            onPressed: () {
              _flutterAliOttHotlinePlugin.startHotlineCall(
                phoneApp,
                fullName,
                avatarGuest,
              );
            },
            child: Text('Call Hotline'),
          ),
        ),
        if (_call != null)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: CallingPage(
              _flutterAliOttHotlinePlugin,
              _call!,
              () {
                setState(() {
                  _call = null;
                });
              },
            ),
          ),
      ]),
    );
  }
}
