import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase(
        databaseURL:
            "https://book-my-etaxi-default-rtdb.asia-southeast1.firebasedatabase.app")
    .ref();

Future<void> uploadFranchiseData() async {
  Map map = {
    "Tk5InbZTTPQT2DnQ4VBmsxabrBy1": {"name": "Aryan"},
    "qiOucjFR8uhPSaNqYaU0tKqujxu2": {"name": "Swaastik"},
    "zb2TPu9TiBS136HqZnESHs6JIL13": {"name": "Abhay"},
  };
  databaseReference.child("city_dealer").set(map);
}

Future<void> uploadCityDealerData() async {
  Map map = {
    "Z9NccpyL2hW3vphzvBn0VV8Ik2B3": {
      "name": "Shabbir",
      "city_dealer": "Tk5InbZTTPQT2DnQ4VBmsxabrBy1"
    },
    "tlIWev2H4MYcBn5z2keuYfySehx2": {
      "name": "Kim",
      "city_dealer": "qiOucjFR8uhPSaNqYaU0tKqujxu2"
    },
    "MT1ZS8Rg6IN9eLPUH8TVz57hvay2": {
      "name": "Manish",
      "city_dealer": "qiOucjFR8uhPSaNqYaU0tKqujxu2"
    },
  };
  databaseReference.child("franchise").set(map);
}
