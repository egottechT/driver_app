import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/screens/onboarding_screens/select_vehicle_screen.dart';
import 'package:driver_app/screens/preformance_screen.dart';
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
