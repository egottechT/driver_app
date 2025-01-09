import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/repository/user_repo.dart';
import 'package:driver_app/service/authentication.dart';
import 'package:driver_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:driver_app/widgets/elevated_button_style.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLoading = false;

  Widget centerCircularWidget() {
    return const Flexible(
        child: Row(
          children: [
            SizedBox(
              width: 150,
            ),
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            Flexible(
                child: SizedBox(
                  width: 150,
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryColor,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            "assets/images/login_screen.png",
                            scale: 1.5,
                          )),
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text.rich(TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Sign up to start your trip with ",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextSpan(
                            text: "BOOK MY ETAXI ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "enjoy the ride & start Good Earnings.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ])),
                        const SizedBox(
                          height: 25,
                        ),
                        showLoading
                            ? centerCircularWidget()
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/phoneNumberSetup");
                              },
                              style: elevatedButtonStyle(
                                  backgroundColor: Colors.black),
                              child: const Text(
                                "Continue with Phone Number",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    showLoading = true;
                                  });
                                  try {
                                    User? result = await doGmailLogin();
                                    if (result != null) {
                                      bool isExist = await UserRepo()
                                          .checkDatabaseForUser(
                                          result.uid.toString());
                                      if (context.mounted) {
                                        if (isExist) {
                                          Navigator.of(context).pushNamed(
                                              "/permissionScreen");
                                        } else {
                                          Navigator.of(context).pushNamed(
                                              "/registrationScreen");
                                        }
                                      }
                                    } else {
                                      if (context.mounted) {
                                        context.showErrorSnackBar(
                                            message:
                                            "There is some error while LogIn. Please try again later");
                                      }
                                    }
                                  } catch (e) {
                                    debugPrint("Some error occured $e");
                                    context.showErrorSnackBar(
                                        message:
                                        "There is some error while LogIn. Please try again later");
                                  }
                                  setState(() {
                                    showLoading = false;
                                  });
                                },
                                style: elevatedButtonStyle(
                                  backgroundColor: Colors.white,
                                ),
                                child: Image.asset(
                                  "assets/images/google_icon.png",
                                  height: 30,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                String url =
                                    'https://docs.google.com/document/d/1jw_tbat4gmOYtWoMHgVmNLjH1Orw9L4PCE7eYWNfT4s/edit?usp=sharing';
                                if (!await launchUrl(Uri.parse(url))) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: const Text.rich(TextSpan(children: <
                                  TextSpan>[
                                TextSpan(
                                  text:
                                  "By continuing, you agree that you have read and accept our ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                TextSpan(
                                  text: "T&C ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: "and ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                TextSpan(
                                  text: "Privacy Policy.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ])),
                            )),
                      ],
                    ))
              ],
            ),
          )),
    );
  }
}
