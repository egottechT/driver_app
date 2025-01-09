import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:firebase_database/firebase_database.dart';

class DealerRepo {
  final databaseReference = FirebaseDatabase.instance.ref();

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
}
