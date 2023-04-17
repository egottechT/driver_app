import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Kaur";
  String phoneNumber = "+91 94589 42703";
  String email = "aryanbisht@gmail.com";



  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
  );

  TextStyle textStyle =
      TextStyle(fontWeight: FontWeight.bold, color: secondaryColor);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // firstCardView("Hi $name!",phoneNumber,context),
              const SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email verification pending",
                        style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Please verify your email-id"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            email,
                            style: const TextStyle(
                                decoration: TextDecoration.underline),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Verify Your Email-id",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: ListTile(
                  title: Text(
                    "View your profile",
                    style: textStyle,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: ListTile(
                  title: Text(
                    "Choose your communication Methods",
                    style: textStyle,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: ListTile(
                  title: Text(
                    "About Book my ETaxi",
                    style: textStyle,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: ListTile(
                  title: Text(
                    "Privacy Policy/Terms & Conditions",
                    style: textStyle,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: ListTile(
                  title: Text(
                    "Help & Support",
                    style: textStyle,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text("LogOut"),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
