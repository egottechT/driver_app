import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/screens/setting_screens/wallet/balance_screen.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/select_vehicle_screen.dart';
import 'package:driver_app/screens/setting_screens/driver_history_screen.dart';
import 'package:driver_app/screens/setting_screens/help_and_support_screen.dart';
import 'package:driver_app/screens/setting_screens/preformance_screen.dart';
import 'package:driver_app/screens/setting_screens/verify_email_screen.dart';
import 'package:driver_app/screens/setting_screens/wallet_screen.dart';
import 'package:driver_app/screens/share_app_earn.dart';
import 'package:driver_app/screens/starting_screens/registration_screen.dart';
import 'package:driver_app/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<Pair<String, dynamic>> nameAndFunctionList(BuildContext context) {
  List<Pair<String, dynamic>> nameFunctions = [
    Pair("Performance", () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PerformanceScreen()));
    }),
    Pair("Vehicle Information", () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SelectVehicleScreen(
                isFromStart: false,
              )));
    }),
    Pair("Digital KYC Customer Verification", () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const VerifyEmailScreen()));
    }),
    Pair("My Wallet", () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const BalanceScreen()));
    }),
    // Pair("Book My Etaxi Money", () {
    //   debugPrint("Etaxi");
    // }),
    // Pair("Refer and Earn", () {
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => const ShareAppEarnScreen()));
    // }),
    Pair("Setting", () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const RegistrationScreen()));
    }),
    Pair("Help and Support", () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HelpAndSupportScreen()));
    }),
    Pair("LogOut", () {
      signOut(context);
      Navigator.of(context).pushReplacementNamed('/loginScreen');
    }),
    Pair("Call for Emergency", () async {
      Uri calling = Uri.parse('tel:${9458942703}');
      await launchUrl(calling);
    }),
  ];
  return nameFunctions;
}

String? nullValidator(dynamic value) {
  if (value == null || value!.isEmpty) {
    return "Some value is required";
  }
  return null;
}

List<dynamic> getFunctionList(BuildContext context) {
  List<dynamic> list = [
    () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const WalletScreen()));
    },
    () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DriveHistoryScreen()));
    },
    () {},
    () {},
    () async {
      Uri phoneNumber = Uri.parse('tel:8910045925');
      await launchUrl(phoneNumber);
    },
  ];
  return list;
}
