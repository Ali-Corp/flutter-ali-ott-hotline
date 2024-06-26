import 'dart:async';

import 'package:flutter_ali_ott_hotline/src/entities/ALIOTTCallState.dart';

class ALIOTTNotificationService {
  ALIOTTNotificationService._privateConstructor();

  static final ALIOTTNotificationService _instance =
      ALIOTTNotificationService._privateConstructor();

  static ALIOTTNotificationService get instance => _instance;
  final onstreamCallState = StreamController<ALIOTTCallState>.broadcast();
  final onstreamCallConnectedState =
      StreamController<ALIOTTCallConnectedState>.broadcast();
  final onstreamConnectedDate = StreamController<DateTime?>.broadcast();
}
