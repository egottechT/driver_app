import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/select_vehicle_screen.dart';
import 'package:driver_app/screens/setting_screens/driver_history_screen.dart';
import 'package:driver_app/screens/setting_screens/payment_screen.dart';
import 'package:driver_app/screens/setting_screens/preformance_screen.dart';
import 'package:driver_app/screens/setting_screens/wallet_screen.dart';
import 'package:flutter/material.dart';

List<Pair<String, dynamic>> nameAndFunctionList(BuildContext context) {
  List<Pair<String, dynamic>> nameFunctions = [
    Pair("Performance", () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const PerformanceScreen()));
    }),
    Pair("Vehicle Information", () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SelectVehicleScreen()));
    }),
    Pair("Digital KYC Customer Verification", () {}),
    Pair("Deposit Cash", () {}),
    Pair("Book My Etaxi Money", () {
      debugPrint("Etaxi");
    }),
    Pair("Refer and Earn", () {}),
    Pair("Setting", () {}),
    Pair("Help and Support", () {}),
    Pair("EXIT Book My Etaxi Cab", () {}),
    Pair("Call for Emergency", () {}),
  ];
  return nameFunctions;
}

String? nullValidator(dynamic value) {
  if (value == null || value!.isEmpty) {
    return "Some value is required";
  }
  return null;
}

List<dynamic> getFunctionList(BuildContext context){
  List<dynamic> list = [
    (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const WalletScreen()));
    },
    (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const DriveHistoryScreen()));
    },
    (){},
    (){},
    (){},
  ];
  return list;
}