import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_notification_channel/flutter_notification_channel.dart';
// import 'package:flutter_notification_channel/notification_importance.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tzData;

class LocalNoticeService {
  // final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool sendNotification = false;
  //
  // Future<void> setup() async {
  //   // #1
  //   const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const iosSetting = DarwinInitializationSettings();
  //   await FlutterNotificationChannel.registerNotificationChannel(
  //     description: 'To receive coustomer request',
  //     id: 'driver',
  //     importance: NotificationImportance.IMPORTANCE_HIGH,
  //     name: 'Request driver',
  //     allowBubbles: true,
  //     enableVibration: true,
  //     enableSound: true,
  //     showBadge: true,
  //   );
  //   // #2
  //   const initSettings =
  //       InitializationSettings(android: androidSetting, iOS: iosSetting);
  //
  //   // #3
  //   await _localNotificationsPlugin.initialize(initSettings).then((_) {
  //     debugPrint('setupPlugin: setup success');
  //   }).catchError((Object error) {
  //     debugPrint('Error: $error');
  //   });
  // }
  //
  // void addNotification(
  //     String title, String body, int endTime, String channel) async {
  //   tzData.initializeTimeZones();
  //   final scheduleTime =
  //       tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);
  //
  //   const androidDetail = AndroidNotificationDetails(
  //     "driver", // channel Id
  //     "Request driver", // channel Name
  //   );
  //
  //   final iosDetail = DarwinNotificationDetails();
  //
  //   final noticeDetail = NotificationDetails(
  //     iOS: iosDetail,
  //     android: androidDetail,
  //   );
  //
  //   final id = 0;
  //
  //   await _localNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     scheduleTime,
  //     noticeDetail,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref();

  void readData(BuildContext context, Function function) {
    databaseReference.child('active_driver').onValue.listen((event) {
      debugPrint("Inside here ${sendNotification}");
      var snapshot = event.snapshot.children;
      var values = snapshot.first;
      Map map = values.value as Map;
      if (sendNotification) {
        FlutterBeep.playSysSound(41);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text(
                  "Pickup Request",
                  style: TextStyle(color: Colors.black),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 2,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconWithText(
                            Image.asset(
                              "assets/icons/watch.png",
                              scale: 2.5,
                            ),
                            "5 min",
                            "Min. Time"),
                        iconWithText(
                            Image.asset(
                              "assets/icons/rupee_bag.png",
                              scale: 8,
                            ),
                            "4.49 \₹",
                            "Esti. Earn"),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("77 Color Extension Apt. 690"),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset("assets/images/map_image.png")
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    child: const Text(
                      "REJECT",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    child: const Text(
                      "ACCEPT",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      function(map);
                    },
                  ),
                ],
              );
            });
      }
    });
  }

  iconWithText(Image icon, String s, String t) {
    TextStyle largeText = const TextStyle(
        color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold);
    TextStyle smallText = TextStyle(color: Colors.grey, fontSize: 15);
    return Column(
      children: [
        icon,
        const SizedBox(
          height: 5,
        ),
        Text(
          s,
          style: largeText,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          t,
          style: smallText,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
