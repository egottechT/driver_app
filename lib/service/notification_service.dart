import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class LocalNoticeService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool sendNotification = false;

  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();
    await FlutterNotificationChannel.registerNotificationChannel(
      description: 'To receive coustomer request',
      id: 'driver',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Request driver',
      allowBubbles: true,
      enableVibration: true,
      enableSound: true,
      showBadge: true,
    );
    // #2
    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  void addNotification(String title, String body, int endTime, String channel) async {
    tzData.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    const androidDetail = AndroidNotificationDetails(
        "driver", // channel Id
        "Request driver", // channel Name
        );

    final iosDetail = DarwinNotificationDetails();

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    final id = 0;

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref();

  void readData() {
    databaseReference.child('active_driver').onValue.listen((event) {
      debugPrint("Inside here ${sendNotification}");
      var snapshot = event.snapshot.children;
      for (var values in snapshot) {
        Map map = values.value as Map;
        if (sendNotification) {
          LocalNoticeService().addNotification(
            map['title'],
            map['body'],
            DateTime.now().millisecondsSinceEpoch + 1000,
            'testing',
          );
        }
      }
    });
  }
}
