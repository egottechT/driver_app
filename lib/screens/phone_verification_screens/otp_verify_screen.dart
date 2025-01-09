import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/provider/otp_listener.dart';
import 'package:driver_app/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:driver_app/widgets/elevated_button_style.dart';
class OTPVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerifyScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerifyScreen> createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  TextEditingController controller = TextEditingController();
  String otp = "";
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    otp = Provider.of<OtpProvider>(context).text;
    controller.text = otp;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.black, // <-- SEE HERE
        ),
        title: const Text(
          "Verify Mobile",
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
                  height: 25,
                ),
                Image.asset(
                  "assets/icons/phone.png",
                  scale: 1.5,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "We were unable to auto-verify your mobile number. Please enter the code tested to ${widget.phoneNumber}",
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: controller,
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
                  await checkOTP(otp, context);
                  setState(() {
                    showLoading = false;
                  });
                }
              },
              style: elevatedButtonStyle(backgroundColor: Colors.black),
              child: showLoading
                  ? const CircularProgressIndicator()
                  : const Text("Submit"),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed("/phoneNumberSetup");
                    },
                    child: const Text(
                      "Change Number",
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
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
