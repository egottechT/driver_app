import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase(databaseURL: "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app").ref();

Future<void> addUserToDatabase(String name) async {
  try {
    await databaseReference.child(name).set({
        "created": true
    });
  }
  catch(e){
    print(e.toString());
  }
}

Future<List<String>> readData() async {
  List<String> msg = [];
  final snapshot = await databaseReference.get();
  for(var snap in snapshot.children){
    final uid = snap.key as String;
    msg.add(uid);
  };
  return msg;
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

