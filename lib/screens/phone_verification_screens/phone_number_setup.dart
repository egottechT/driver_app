import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/service/authentication.dart';
import 'package:driver_app/widgets/phone_number_view.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/elevated_button_style.dart';
class PhoneNumberSetup extends StatefulWidget {
  const PhoneNumberSetup({Key? key}) : super(key: key);

  @override
  State<PhoneNumberSetup> createState() => _PhoneNumberSetupState();
}

class _PhoneNumberSetupState extends State<PhoneNumberSetup> {
  late String phoneNumber;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    phoneNumber = "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black, // <-- SEE HERE
            ),
            title: const Text(
              "Enter your Phone Number",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: primaryColor,
          ),
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    phoneNumberForm(),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                )),
                ElevatedButton(
                  onPressed: () async {
                    print(phoneNumber);
                    if (phoneNumber.length == 13) {
                      setState(() {
                        showLoading = true;
                      });
                      signInWithPhoneNumber(phoneNumber, context);

                      await Future.delayed(const Duration(seconds: 10));
                      setState(() {
                        showLoading = false;
                      });
                    }
                  },
                  style:
                  elevatedButtonStyle(backgroundColor: Colors.black),
                  child: const Text("Next"),
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          )),
    );
  }

  Widget phoneNumberForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enter Phone number for verification",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "This phone number is available to contact you and communicate all ride or trip-details.",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(
          height: 50,
        ),
        showLoading
            ? const CircularProgressIndicator()
            : PhoneNumberInput(
                onValueChange: (String value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
        const SizedBox(
          height: 25,
        ),
        Text(
          "Find your account details or changed Number?",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              color: secondaryColor),
        )
      ],
    );
  }
}
