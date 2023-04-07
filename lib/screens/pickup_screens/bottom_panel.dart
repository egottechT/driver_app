import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/message_screen.dart';
import 'package:driver_app/screens/pickup_screens/pick_otp_check.dart';
import 'package:driver_app/screens/setting_screens/payment_screen.dart';
import 'package:driver_app/service/database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget bottomPanelLayout(
    Map map, BuildContext context, bool isPickup, String carType) {
  return Container(
    color: Colors.grey[200],
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Pick-up",
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: secondaryColor)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/icons/$carType.png",
                      width: 100,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer Details",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(map["title"] ?? ""),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Call to Customer",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(map["phoneNumber"] ?? ""),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Destination Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(map["destination"]["location"] ?? ""),
                    ],
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            InkWell(
              onTap: () async {
                String phoneNumber = map["phoneNumber"] ?? "9458942703";
                Uri calling = Uri.parse('tel:$phoneNumber');
                await launchUrl(calling);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secondaryColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MessageScreen()));
              },
              child: const Text("Message your customer.."),
            ))
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            if (isPickup) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PickOtpScreen(map: map)));
            } else {
              await updateFinishTrip();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentScreen(map: map)));
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: Text(
            isPickup ? "Continue" : "End Trip",
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
    ),
  );
}
