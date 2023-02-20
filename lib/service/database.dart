import 'dart:async';

import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

final databaseReference = FirebaseDatabase(databaseURL: "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app").ref();


Future<UserModel> getUserInfo(BuildContext context){
  Completer<UserModel> complete = Completer();
  databaseReference.child("customer").child(FirebaseAuth.instance.currentUser!.uid.toString()).once().then((value){
    Map map = value.snapshot.value as Map;
    debugPrint("Values :- ${map.toString()}");
    UserModel model = UserModel().getDataFromMap(map);
    complete.complete(model);
    Provider.of<UserModelProvider>(context,listen: false).setData(model);
  });
  return complete.future;
}

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

void addDriverInfoInTrip(String key,BuildContext context,LatLng driverLocation){
  final UserModel userData = Provider.of<UserModelProvider>(context,listen: false).data;

  databaseReference.child("active_driver").child(key).child("driver_info").set({
    "name": userData.name,
    "vehicleNumber" : "UK4976 (NOT Store)",
    "phoneNumber": userData.phoneNumber,
    "rating" : "4.6",
    "lat": driverLocation.latitude,
    "long": driverLocation.longitude
  });
}

