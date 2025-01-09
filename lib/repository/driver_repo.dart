import 'dart:async';
import 'dart:math';

import 'package:driver_app/model/raitng_model.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverRepo {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<Map<String, String>> getDriverUuidByPhoneNumber(
      String phoneNumber) async {
    try {
      // Reference to the Firebase Realtime Database
      final DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref("driver");

      // Fetch the driver data once
      final DataSnapshot snapshot = await databaseRef.get();

      // Check if the snapshot contains data
      if (snapshot.exists) {
        final Map<dynamic, dynamic>? driversData =
            snapshot.value as Map<dynamic, dynamic>?;

        // Iterate over the drivers data
        if (driversData != null) {
          for (final uuid in driversData.keys) {
            final dynamic driverData = driversData[uuid];

            // Check if the driver data contains a matching phone number
            if (driverData is Map<dynamic, dynamic> &&
                driverData['phoneNumber'] == phoneNumber) {
              final String name =
                  driverData['name'] ?? "Unknown"; // Extract the name
              return {
                'uuid': uuid.toString(),
                'name': name,
              };
            }
          }
        }
      }

      // If no match is found, return no match message
      return {"name": "No driver match"};
    } catch (e) {
      // Handle any errors that occur
      return {"name": "Error: ${e.toString()}"};
    }
  }

  Future<void> addDriverInfoInTrip(
      BuildContext context, UserModel userData, LatLng driverLocation) async {
    // debugPrint("Uploading the data");
    int randomNumber = Random().nextInt(9000) + 1000;
    await databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .child("driver_info")
        .once()
        .then((value) {
      if (!value.snapshot.exists) {
        databaseReference
            .child("trips")
            .child(DatabaseUtils.customerKey)
            .child("driver_info")
            .set({
          "name": userData.name,
          "vehicleNumber": userData.vehicleNumber,
          "phoneNumber": userData.phoneNumber,
          "rating": "4.6",
          "lat": driverLocation.latitude,
          "long": driverLocation.longitude,
          "otp": randomNumber,
          'id': FirebaseAuth.instance.currentUser!.uid.toString()
        });
      }
    });
  }

  Future<List<RatingModel>> fetchRatingData() async {
    List<RatingModel> list = [];
    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("rating")
        .once()
        .then((value) {
      for (var event in value.snapshot.children) {
        Map map = event.value as Map;
        RatingModel model = RatingModel().fromMap(map);
        list.add(model);
      }
    });
    return list;
  }

  Future<void> addReferAndEarn(String uid) async {
    await databaseReference
        .child("driver")
        .child(uid)
        .once()
        .then((value) async {
      if (value.snapshot.exists) {
        await databaseReference
            .child("driver")
            .child(uid)
            .child("refers")
            .update({FirebaseAuth.instance.currentUser!.uid.toString(): 1});
      }
    });
  }

  Future<bool> checkAlreadyDriver() async {
    bool exist = false;
    await databaseReference
        .child("trips")
        .child(DatabaseUtils.customerKey)
        .child("driver_info")
        .once()
        .then((event) {
      exist = event.snapshot.exists;
    });
    return exist;
  }
}
