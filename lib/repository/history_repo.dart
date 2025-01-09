import 'package:driver_app/model/trip_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HistoryRepo {
  final databaseReference = FirebaseDatabase.instance.ref();

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
}
