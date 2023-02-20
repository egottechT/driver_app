import 'dart:async';

import 'package:driver_app/model/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

final databaseReference = FirebaseDatabase(databaseURL: "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app").ref();

Future<void> addUserToDatabase(String name,UserModel model) async {
  try {
    await databaseReference.child("driver").child(name).set(UserModel().toMap(model));
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<bool> checkDatabaseForUser(String uid) async{
  Completer<bool> completer = Completer();
  databaseReference.child("driver").child(uid).onValue.listen((event) {
    completer.complete(event.snapshot.exists);
    });
  return completer.future;
}

void addDriverInfoInTrip(String key){
  databaseReference.child("active_driver").child(key).child("driver_info").set({
    "name": "Aryan",
    "vehicleNumber" : "UK07AB4976",
    "phoneNumber": "908616413",
    "rating" : "4.6",
    //TODO ADD LAT AND LNG FOR DRIVER
  });
}

