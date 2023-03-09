import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({Key? key}) : super(key: key);

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  TextStyle customerStyle({FontWeight weight = FontWeight.normal}) {
    return TextStyle(color: secondaryColor, fontWeight: weight);
  }

  List items = [
    "Identity Details",
    "Aadhar Card",
    "Local Address Proof",
    "Driver License number",
    "Profile Picture",
    "Vehicle Insurance",
    "Passbook/Cancelled Check photo",
    "Pan Card",
    "Pollution Under Control",
    "Vehicle Registration Certificate (RC)",
    "Vehicle Permit",
    "Fitness Certificate",
    "Vehicle Audit",
    "Profile Setting",
    "Cancel & Reset",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Documents",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text:
                            "-Please upload the Documents required to start driving with",
                        style: customerStyle()),
                    TextSpan(
                        text: " BOOK MY ETAXI",
                        style: customerStyle(weight: FontWeight.bold)),
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "-24/7 driver support is available & flexible working hours",
                      style: customerStyle()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "-Check your destination place before you accept a ride.",
                      style: customerStyle()),
                ],
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              primary: false,
              itemBuilder: (context, index) {
                return cardViewWithText(
                    "Step ${index + 1}: ${items[index]}", () {});
              },
              itemCount: items.length,
              shrinkWrap: true,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context,ModalRoute.withName("/managementScreen"));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }

  Widget cardViewWithText(String title, dynamic onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          child: ListTile(
            leading: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            title: Text(title),
          ),
        ));
  }
}
