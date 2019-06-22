import 'dart:async';

import 'package:flutter/services.dart';

class Data {
  static const MethodChannel _channel =
      const MethodChannel('data');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
