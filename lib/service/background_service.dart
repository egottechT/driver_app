import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

final service = FlutterBackgroundService();

Future<void> initializeService() async {
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    debugPrint("Working fine");
    if (service is AndroidServiceInstance) {
      service.setAsBackgroundService();
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  });
}
