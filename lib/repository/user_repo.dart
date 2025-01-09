import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/repository/driver_repo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class UserRepo {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<void> getUserInformation(BuildContext context, String uid) async {
    UserModel model = UserModel();
    await databaseReference.child("driver").child(uid).once().then((value) {
      if (value.snapshot.value == null) {
        context.showErrorSnackBar(message: "Please log-out and Log-in again");
        return;
      }
      Map map = value.snapshot.value as Map;
      model = UserModel().getDataFromMap(map);
      model.key = value.snapshot.key.toString();
    });
    if (context.mounted) {
      Provider.of<UserModelProvider>(context, listen: false).setData(model);
    }
  }

  Future<void> getUserInfo(
      BuildContext context, String uid, LocationData currentLocation) async {
    databaseReference.child("driver").child(uid).once().then((value) {
      Map map = value.snapshot.value as Map;
      UserModel model = UserModel().getDataFromMap(map);
      DriverRepo().addDriverInfoInTrip(
          context,
          model,
          LatLng(currentLocation.latitude as double,
              currentLocation.longitude as double));
    });
  }

  Future<void> addUserToDatabase(String name, UserModel model) async {
    try {
      await databaseReference
          .child("driver")
          .child(name)
          .update(UserModel().toMap(model));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> checkDatabaseForUser(String uid) async {
    bool isExist = false;
    await databaseReference.child("driver").child(uid).once().then((event) {
      isExist = event.snapshot.exists;
    });
    return isExist;
  }

  Future<void> uploadRatingUser(
      Map map, double stars, String title, String name) async {
    await databaseReference
        .child("customer")
        .child(map["id"])
        .child("rating")
        .push()
        .set({
      "rating": stars,
      "description": title,
      "customerName": name,
      "date": DateTime.now().toString()
    });
  }
}
