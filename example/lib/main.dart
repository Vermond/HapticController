import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:haptic_controller/haptic_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _canHaptic = false;

  @override
  void initState() {
    super.initState();
    initHapticEngine();
  }

  Future<void> initHapticEngine() async {
    bool haptic;

    try {
      haptic = await HapticController.canHaptic;
    } on PlatformException catch (e) {
      print('Error : ${e.message}');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _canHaptic = haptic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Haptic : ${_canHaptic ? 'YES' : 'NO'}'),
              TextButton(
                onPressed: () {
                  HapticController.haptic();
                },
                child: Text('Simple Haptic'),
              ),
              TextButton(
                onPressed: () {
                  List<double> delayTime = [0, 1, 2];
                  List<double> duration = [0.5, 0.5, 1];
                  List<double> intensities = [1, 0.5, 1];

                  HapticController.hapticPattern(delayTime: delayTime, duration: duration, intensities: intensities);
                },
                child: Text('Haptic Pattern'),
              ),
              TextButton(
                onPressed: () {
                  List<double> delayTime = [1, 2, 3];
                  List<double> duration = [0.1, 0.2, 0.3];
                  List<double> intensities = [0.3, 0.5, 0.8];

                  HapticController.hapticPattern(delayTime: delayTime, duration: duration, intensities: intensities);
                },
                child: Text('Haptic Pattern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
