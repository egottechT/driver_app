import 'dart:async';

import 'package:driver_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripRepo {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<void> updateLatLng(LatLng driver) async {
    if (DatabaseUtils.customerKey.isEmpty) {
      return;
    }

    databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .child("driver_info")
        .once()
        .then((event) {
      if (event.snapshot.exists) {
        databaseReference
            .child("trips")
            .child(DatabaseUtils.customerKey)
            .child("driver_info")
            .update({"lat": driver.latitude, "long": driver.longitude});
      }
    });
    updateLocationForMe(driver);
  }

  Future<void> updateLocationForMe(LatLng driver) async {
    databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("position")
        .update({"lat": driver.latitude, "long": driver.longitude});
  }

  Future<String> checkTripOtp(String otp) async {
    String status = "false";

    await databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .child("driver_info")
        .once()
        .then((value) {
      Map map = value.snapshot.value as Map;
      String code = (map["otp"] ?? 0).toString();
      status = (code == otp) ? "true" : "false";
      status = map["applied"] ?? status;
    });
    return status;
  }

  Future<void> updateFinishTrip() async {
    await databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .update({"isFinished": true});
  }

  Future<void> uploadTripStartData() async {
    databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .update({"tripStarted": true});
    databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .child("driver_info")
        .update({"applied": "done"});
  }


}
