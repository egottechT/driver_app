// import 'dart:async';
// import 'dart:ui';
// import 'package:driver_app/service/notification_service.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
//
// final service = FlutterBackgroundService();
//
// Future<void> initializeService() async {
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//     ),
//   );
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     debugPrint("Working fine");
//     // readData();
//     if (service is AndroidServiceInstance) {
//       service.on('setAsBackground').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }
//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });
//   });
// }
//
// final databaseReference = FirebaseDatabase(
//     databaseURL: "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app")
//     .ref();
//
// void readData() {
//   debugPrint("Checking database");
//   databaseReference
//       .child('active_driver')
//       .onValue
//       .listen((event) {
//     debugPrint("Inside here");
//     var snapshot = event.snapshot.children;
//     for (var values in snapshot) {
//       Map map = values.value as Map;
//       LocalNoticeService().addNotification(
//         map['title'],
//         map['body'],
//         DateTime
//             .now()
//             .millisecondsSinceEpoch + 1000,
//         'testing',
//       );
//     }
//   });
// }
