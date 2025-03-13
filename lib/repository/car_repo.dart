import 'package:driver_app/repository/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CarRepo {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<void> uploadDocumentPhoto(String key) async {
    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("documents")
        .update({key: true});
  }

  Future<void> uploadCarType(String carType, BuildContext context) async {
    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("car_details")
        .child("car_type")
        .set(carType);

    await UserRepo().getUserInformation(context);
  }

  Future<void> uploadCarDetails(
      Map<String, dynamic> map, BuildContext context) async {
    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("car_details")
        .update(map);

    await UserRepo().getUserInformation(context);
  }
}
