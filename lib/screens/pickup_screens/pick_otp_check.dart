import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/repository/trip_repo.dart';
import 'package:driver_app/screens/pickup_screens/pickup_screen.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/elevated_button_style.dart';
class PickOtpScreen extends StatefulWidget {
  final Map map;

  const PickOtpScreen({super.key, required this.map});

  @override
  State<PickOtpScreen> createState() => _PickOtpScreenState();
}

class _PickOtpScreenState extends State<PickOtpScreen> {
  String otp = "";
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.black, // <-- SEE HERE
        ),
        title: const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
                child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  "assets/icons/phone.png",
                  scale: 1.5,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Ask Customer for OTP to Start trip",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                  ),
                  onChanged: (val) {
                    otp = val;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ],
            )),
            ElevatedButton(
              onPressed: () async {
                if (otp.isNotEmpty) {
                  setState(() {
                    showLoading = true;
                  });
                  String otpCheck = await TripRepo().checkTripOtp(otp);
                  setState(() {
                    showLoading = false;
                  });
                  if (otpCheck == "true") {
                    TripRepo().uploadTripStartData();
                    if (context.mounted) {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PickUpScreen(map: widget.map, isPickUp: false)));
                    }
                  } else if (otpCheck == "done") {
                    context.showErrorSnackBar(
                        message:
                            "This ride is already taken by some other driver.");
                  } else {
                    context.showErrorSnackBar(message: "OTP is wrong");
                  }
                }
              },
              style: elevatedButtonStyle(backgroundColor: Colors.black),
              child: showLoading
                  ? const CircularProgressIndicator()
                  : const Text("Verify & Start trip"),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
