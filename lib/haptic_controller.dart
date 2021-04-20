import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticController {
  static const MethodChannel _channel = const MethodChannel('haptic_controller');

  static Future<double> get hapticTime async {
    final double result = await _channel.invokeMethod('hapticTime');
    return result;
  }

  static void setHapticTime(double value) async {
    await _channel.invokeMethod('hapticTime', {'set': value});
  }

  static Future<double> get hapticIntensity async {
    final double result = await _channel.invokeMethod('hapticIntensity');
    return result;
  }

  static void setHapticIntensity(double value) {
    _channel.invokeMethod('hapticIntensity', {'set': value});
  }

  static Future<bool> get canHaptic async {
    final bool result = await _channel.invokeMethod('canHaptic');
    return result;
  }

  static void haptic() async {
    await _channel.invokeMethod('haptic');
  }

  static void hapticPattern({@required List<double> delayTime, List<double> duration = const [0.1], List<double> intensities = const [1]}) async {
    await _channel.invokeMethod(
        'hapticPattern', <String, Float64List>{'delayTime': Float64List.fromList(delayTime), 'duration': Float64List.fromList(duration), 'intensities': Float64List.fromList(intensities)});
  }
}
