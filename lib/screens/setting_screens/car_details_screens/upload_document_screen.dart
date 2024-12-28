import 'package:driver_app/Utils/commonData.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/document_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:driver_app/widgets/elevated_button_style.dart';
class UploadDocumentScreen extends StatefulWidget {
  final bool isFromStart;

  const UploadDocumentScreen({Key? key, required this.isFromStart})
      : super(key: key);

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  List documentName = List.generate(15, (index) => "");

  @override
  void initState() {
    super.initState();
    readData();
  }

  TextStyle customerStyle({FontWeight weight = FontWeight.normal}) {
    return TextStyle(color: secondaryColor, fontWeight: weight);
  }

  List items = [
    "Identity Details",
    "Aadhar Card",
    "Local Address Proof",
    "Driver License number",
    "Vehicle Insurance",
    "Passbook/Cancelled Check photo",
    "Pan Card",
    "Pollution Under Control",
    "Vehicle Registration Certificate (RC)",
    "Vehicle Permit",
    "Fitness Certificate",
    "Vehicle Audit",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Documents",
          style: TextStyle(color: Colors.white),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              primary: false,
              itemBuilder: (context, index) {
                return cardViewWithText(index, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DocumentDetailScreen(
                          documentName: documentName[index])));
                });
              },
              itemCount: items.length,
              shrinkWrap: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget.isFromStart) {
                  LocationData currentLocation = await getCurrentLocation();
                  if (context.mounted) {
                    // LocalNoticeService.sendNotification = true;
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/managementScreen",
                        arguments: LatLng(currentLocation.latitude as double,
                            currentLocation.longitude as double),
                        (route) => false);
                  }
                } else {
                  Navigator.popUntil(
                      context, ModalRoute.withName("/managementScreen"));
                }
              },
              style: elevatedButtonStyle(backgroundColor: Colors.black),
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }

  Widget cardViewWithText(int index, dynamic onTap) {
    String title = "Step ${index + 1}: ${items[index]}";
    UserModel model = Provider.of<UserModelProvider>(context).data;

    return GestureDetector(
        onTap: onTap,
        child: Card(
          child: ListTile(
            leading: model.documents[documentName[index]]
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : const Icon(null),
            title: Text(title),
          ),
        ));
  }

  void readData() {
    List list = List.empty(growable: true);
    documentsValue.forEach((key, value) {
      list.add(key);
    });
    setState(() {
      documentName = list;
    });
  }
}
