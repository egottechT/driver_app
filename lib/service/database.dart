import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/message_model.dart';
import 'package:driver_app/model/raitng_model.dart';
import 'package:driver_app/model/trip_model.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/service/push_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class DatabaseUtils {
  final databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseStorage storage = FirebaseStorage.instance;
  static String customerKey = "";
  static StreamSubscription<DatabaseEvent>? messageListener,
      notificationListener,
      driverInfoListener,
      cancelListener;

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
      addDriverInfoInTrip(
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
          .set(UserModel().toMap(model));
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

  Future<void> addDriverInfoInTrip(
      BuildContext context, UserModel userData, LatLng driverLocation) async {
    // debugPrint("Uploading the data");
    int randomNumber = Random().nextInt(9000) + 1000;
    await databaseReference
        .child("trips")
        .child(customerKey)
        .child("driver_info")
        .once()
        .then((value) {
      if (!value.snapshot.exists) {
        databaseReference
            .child("trips")
            .child(customerKey)
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

  Future<bool> checkAlreadyDriver() async {
    bool exist = false;
    await databaseReference
        .child("trips")
        .child(customerKey)
        .child("driver_info")
        .once()
        .then((event) {
      exist = event.snapshot.exists;
    });
    return exist;
  }

  Future<void> updateLatLng(LatLng driver) async {
    if (customerKey.isEmpty) {
      return;
    }

    databaseReference
        .child("trips")
        .child(customerKey)
        .child("driver_info")
        .once()
        .then((event) {
      if (event.snapshot.exists) {
        databaseReference
            .child("trips")
            .child(customerKey)
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
        .child(customerKey)
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

  Future<void> uploadDummyData(Map map) async {
    databaseReference.child("trips").push().set(map);
  }

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

    await getUserInformation(
        context, FirebaseAuth.instance.currentUser!.uid.toString());
  }

  Future<void> uploadCarDetails(
      Map<String, dynamic> map, BuildContext context) async {
    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("car_details")
        .update(map);

    await getUserInformation(
        context, FirebaseAuth.instance.currentUser!.uid.toString());
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

  Future<void> uploadTripHistory(Map map) async {
    TripModel model = TripModel().convertFromTrip(map);
    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("history")
        .push()
        .set(TripModel().toMap(model));
  }

  Future<List<TripModel>> fetchHistoryTrip() async {
    List<TripModel> list = [];
    await databaseReference
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child("history")
        .once()
        .then((value) {
      for (var data in value.snapshot.children) {
        Map map = data.value as Map;
        TripModel model = TripModel().fromMap(map);
        list.add(model);
      }
    });
    return list;
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

  Future<void> updateFinishTrip() async {
    await databaseReference
        .child("trips")
        .child(customerKey)
        .update({"isFinished": true});
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

  Future<void> uploadTripStartData() async {
    databaseReference
        .child("trips")
        .child(customerKey)
        .update({"tripStarted": true});
    databaseReference
        .child("trips")
        .child(customerKey)
        .child("driver_info")
        .update({"applied": "done"});
  }

  Future<void> uploadChatData(String msg) async {
    databaseReference
        .child("trips")
        .child(customerKey)
        .child("messages")
        .push()
        .set({"message": msg, "sender": "driver"});
  }

  Future<List<MessageModel>> fetchMessageData() async {
    List<MessageModel> list = [];
    await databaseReference
        .child("trips")
        .child(customerKey)
        .child("messages")
        .once()
        .then((value) {
      for (var event in value.snapshot.children) {
        Map map = event.value as Map;
        MessageModel model = MessageModel().fromMap(map);
        list.add(model);
      }
    });
    return list;
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

  Future<List<Pair<String, String>>> getFranchiseData(String state) async {
    List<Pair<String, String>> list = [];
    await databaseReference.child("franchise").once().then((value) async {
      if (value.snapshot.exists) {
        for (var event in value.snapshot.children) {
          Map map = event.value as Map;
          if (map['city_dealer'].toString() == state) {
            list.add(Pair(map['name'].toString(), event.key.toString()));
          }
        }
      }
    });
    return list;
  }

  Future<List<Pair<String, String>>> getCityDealerData() async {
    List<Pair<String, String>> list = [];
    await databaseReference.child("city_dealer").once().then((value) async {
      if (value.snapshot.exists) {
        for (var event in value.snapshot.children) {
          Map map = event.value as Map;
          list.add(Pair(map["name"], event.key.toString()));
        }
      }
    });
    return list;
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
