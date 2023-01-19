import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/service/authentication.dart';
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

  Widget FirstCardView() {
    return Card(
        elevation: 0,
        color: Colors.grey[300],
        child: Row(
          children: [
            Column(children: [SizedBox(height: 10,),Image.asset("assets/images/profile.png")]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi ${name}!",
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  phoneNumber,
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            )
          ],
        ));
  }

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
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FirstCardView(),
              SizedBox(
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
                      SizedBox(
                        height: 10,
                      ),
                      Text("Please verify your email-id"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            email,
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
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
              SizedBox(
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
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              SizedBox(
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
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              SizedBox(
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
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              SizedBox(
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
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              SizedBox(
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
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("LogOut"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
