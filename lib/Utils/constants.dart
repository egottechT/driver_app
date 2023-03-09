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

String changeToDate(String date) {
  String? month = date.substring(5,7);
  String dateText = date.substring(8,10);
  String year = date.substring(0,4);

  if(dateText == "01") {
    dateText = "${dateText}st";
  } else if(dateText == "02") {
    dateText = "${dateText}nd";
  } else if(dateText == "03") {
    dateText = "${dateText}rd";
  } else {
    dateText = "${dateText}th";
  }
  return "$dateText\n${numberToMonth[month]!}";
  // month = numberToMonth[month];
}

Map<String, String> numberToMonth = {
  "01": "Jan",
  "02": "Feb",
  "03": "Mar",
  "04": "Apr",
  "05": "May",
  "06": "June",
  "07": "July",
  "08": "Aug",
  "09": "Sept",
  "10": "Oct",
  "11": "Nov",
  "12": "Dec"
};

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