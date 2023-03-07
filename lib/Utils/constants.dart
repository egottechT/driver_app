import 'package:flutter/material.dart';

Color secondaryColor = const Color(0xFF602467);
Color primaryColor = const Color(0xFFddc9e0);
String mapApiKey = "AIzaSyB9veCDeodL87QObk_JXfVvdNvG-JQKafU";

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.green,
  }) {
    ScaffoldMessenger.of(this)..removeCurrentSnackBar()..showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
        maxLines: 2,
      ),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

extension MyDateExtension on DateTime {
  String getDateOnly(){
    return "$year-${month.toString().padLeft(2,'0')}-${day.toString().padLeft(2,'0')}";
  }
}

List<String> statesOfIndia = [
  'Andhra Pradesh',
  'Arunachal Pradesh',
  'Assam',
  'Bihar',
  'Chhattisgarh',
  'Goa',
  'Gujarat',
  'Haryana',
  'Himachal Pradesh',
  'Jammu and Kashmir',
  'Jharkhand',
  'Karnataka',
  'Kerala',
  'Madhya Pradesh',
  'Maharashtra',
  'Manipur',
  'Meghalaya',
  'Mizoram',
  'Nagaland',
  'Odisha',
  'Punjab',
  'Rajasthan',
  'Sikkim',
  'Tamil Nadu',
  'Telangana',
  'Tripura',
  'Uttarakhand',
  'Uttar Pradesh',
  'West Bengal',
  'Andaman and Nicobar Islands',
  'Chandigarh',
  'Dadra and Nagar Haveli',
  'Daman and Diu',
  'Delhi',
  'Lakshadweep',
  'Puducherry',
];