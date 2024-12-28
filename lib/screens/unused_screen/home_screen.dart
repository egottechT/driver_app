import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/elevated_button_style.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "KAUR";

  Widget firstRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 1,
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: "Welcome $name!",
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              TextSpan(
                  text: "\nOn ",
                  style: TextStyle(color: secondaryColor, fontSize: 18)),
              TextSpan(
                  text: "BOOK MY ETAXI ",
                  style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              TextSpan(
                  text: "Partner",
                  style: TextStyle(color: secondaryColor, fontSize: 18)),
            ]))),
        Expanded(
            flex: 2,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset("assets/images/welcome.png"))),
      ],
    );
  }

  Widget secondRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                text: "Your profile is ",
                style: TextStyle(color: secondaryColor, fontSize: 16),
              ),
              TextSpan(
                text: "active Now!",
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              TextSpan(
                text: "\nPlease Verify your ",
                style: TextStyle(color: secondaryColor, fontSize: 16),
              ),
              TextSpan(
                text: "Email id ",
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              TextSpan(
                text: "to continue your",
                style: TextStyle(color: secondaryColor, fontSize: 16),
              ),
              TextSpan(
                text: "\nregistration account",
                style: TextStyle(color: secondaryColor, fontSize: 16),
              ),
            ])),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
          onPressed: () {},
          style: elevatedButtonStyle(backgroundColor: Colors.black),
          child: const ListTile(
            title: Text(
              "Start the application",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
          onPressed: () {},
          style: elevatedButtonStyle(backgroundColor: Colors.black),
          child: const ListTile(
            title: Text(
              "Profile Settings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(flex: 1, child: firstRow()),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        secondRow(),
                        ElevatedButton(
                          onPressed: () {},
                          style: elevatedButtonStyle(
                              backgroundColor: Colors.black),
                          child: const Text("Reset & Cancel"),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
