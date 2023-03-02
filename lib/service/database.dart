import 'dart:async';
import 'dart:math';

import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

final databaseReference = FirebaseDatabase(
    databaseURL: "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app")
    .ref();

String customerKey = "";

Future<void> getUserInfo(BuildContext context, String uid,
    LocationData currentLocation) async {
  debugPrint("Getting user information");

  databaseReference.child("customer").child(uid).once().then((value) {
    Map map = value.snapshot.value as Map;
    debugPrint("Values :- ${map.toString()}");
    UserModel model = UserModel().getDataFromMap(map);
    addDriverInfoInTrip(context, model, LatLng(
        currentLocation.latitude as double,
        currentLocation.longitude as double));
  });
}

Future<void> addUserToDatabase(String name, UserModel model) async {
  try {
    await databaseReference.child("driver").child(name).set(
        UserModel().toMap(model));
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<bool> checkDatabaseForUser(String uid) async {
  Completer<bool> completer = Completer();
  databaseReference
      .child("driver")
      .child(uid)
      .onValue
      .listen((event) {
    completer.complete(event.snapshot.exists);
  });
  return completer.future;
}

void addDriverInfoInTrip(BuildContext context, UserModel userData,
    LatLng driverLocation) {
  debugPrint("Uploading the data");
  int randomNumber = Random().nextInt(9000) + 1000;
  databaseReference.child("trips").child(customerKey).child("driver_info").set({
    "name": userData.name,
    "vehicleNumber": "UK4976 (NOT Store)",
    "phoneNumber": userData.phoneNumber,
    "rating": "4.6",
    "lat": driverLocation.latitude,
    "long": driverLocation.longitude,
    "otp": randomNumber
  });
}

Future<void> updateLatLng(LatLng driver) async {
  if (customerKey.isEmpty) {
    return;
  }
  databaseReference.child("trips").child(customerKey).child("driver_info").onValue.listen((event) {
    if(event.snapshot.exists){

      databaseReference.child("trips").child(customerKey).child("driver_info").update({
        "lat": driver.latitude,
        "long": driver.longitude
      });
    }
  });
}

Map addDummyData() {
  return {
    "phoneNumber": "+919068616413",
    "driver": false,
    "destination": {
      "location": "RispanaPull, Dehradun, Uttarakhand, India",
      "lat": 30.2939471,
      "long": 78.0578826
    },
    "body": "Please Pickup me",
    "pick-up": {
      "location": "73JM + 573, Nehrugram, Dehradun, Uttarakhand248005, India",
      "lat": 30.2803533,
      "long": 78.0831921
    },
    "title": "Aryan bisht"
  };
}