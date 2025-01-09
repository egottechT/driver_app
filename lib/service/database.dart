import 'dart:async';
import 'dart:io';

import 'package:driver_app/service/push_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class DatabaseUtils {
  final databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseStorage storage = FirebaseStorage.instance;
  static String customerKey = "";
  static StreamSubscription<DatabaseEvent>? messageListener,
      notificationListener,
      driverInfoListener,
      cancelListener;

  Future<void> uploadDummyData(Map map) async {
    databaseReference.child("trips").push().set(map);
  }

  Future<void> notificationChangeMessages() async {
    notificationListener = databaseReference
        .child("trips")
        .child(customerKey)
        .child("messages")
        .onChildAdded
        .listen((event) {
      Map map = event.snapshot.value as Map;
      if (map['sender'] == 'customer') {
        NotificationService()
            .showNotification("Message from Customer", map["message"]);
      }
    });
  }

  Future<void> checkDataChanges(BuildContext context) async {
    cancelListener = databaseReference
        .child("trips")
        .child(customerKey)
        .onChildAdded
        .listen((event) {
      if (event.snapshot.key == "cancel_trip") {
        Map map = event.snapshot.value as Map;
        String reason = map["reason"];
        NotificationService().showNotification(
            "Customer has cancelled the ride", "Reason $reason");
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> listenChangeMessages(Function readData) async {
    messageListener = databaseReference
        .child("trips")
        .child(customerKey)
        .child("messages")
        .onChildAdded
        .listen((event) {
      readData();
    });
  }

  Future<void> uploadPhotoToStorage(File file, String name) async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    Reference ref = storage.ref().child('images/$uid/$name.jpg');
    // File compressedFile = await compressImage(file);
    UploadTask uploadTask = ref.putFile(file);
    String url = "a";
    await uploadTask.then((res) async {
      String downloadURL = await res.ref.getDownloadURL();
      debugPrint("url:- $downloadURL");
      url = downloadURL;
    }).catchError((err) {
      // Handle the error.
    });

    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("urls")
        .update({name: url});
  }

  Future<File> compressImage(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 50,
    );
    return File.fromRawPath(result!);
  }

  Future<Map> findTripUsingId(String tripId) async {
    Map data = {};
    await databaseReference.child('trips').child(tripId).once().then((event) {
      data = event.snapshot.value as Map;
      String key = event.snapshot.key.toString();
      debugPrint(data.toString());
      customerKey = key;
    });
    return data;
  }

  void disposeListener() {
    messageListener?.cancel();
    notificationListener?.cancel();
    driverInfoListener?.cancel();
    cancelListener?.cancel();
  }
}
