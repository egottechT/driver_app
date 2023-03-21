import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/service/database.dart';
import 'package:driver_app/widgets/phone_number_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _ownerFormKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController referralController = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String state = "";

  String? nullValidator(dynamic value) {
    if (value == null || value!.isEmpty) {
      return "Some value is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "Register Now On ",
                            style: TextStyle(color: secondaryColor, fontSize: 16),
                          ),
                          TextSpan(
                            text: "BOOK MY ETAXI",
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                "\nPartner! Go Safe drive & \nlooking forward to,reaching this\nopportunity",
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]))
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset("assets/images/register.png"),
                        registrationForm(),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_ownerFormKey.currentState!.validate()) {
                          debugPrint("Inside here");
                          UserModel model = UserModel();
                          model.name = "${firstName.text} ${lastName.text}";
                          model.phoneNumber = phoneNumber.text;
                          User? result = FirebaseAuth.instance.currentUser;
                          addUserToDatabase(
                              result?.uid.toString() as String, model);
                          Navigator.of(context).pushNamed("/permissionScreen");
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text("Next"),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget registrationForm() {
    return Form(
      key: _ownerFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TextFormField(
                  style: _textStyle,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  controller: firstName,
                  validator: nullValidator,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Flexible(
                child: TextFormField(
                  style: _textStyle,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                  controller: lastName,
                  validator: nullValidator,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          PhoneNumberInput(
            onValueChange: (String value) {
              setState(() {
                phoneNumber.text = value;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField(
            items: List.generate(
              statesOfIndia.length,
              (index) => DropdownMenuItem(
                value: statesOfIndia[index],
                child: Text(statesOfIndia[index]),
              ),
            ),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  state = val;
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'City You Drive',
            ),
            validator: nullValidator,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            style: _textStyle,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                labelText: 'REFERRAL CODE',
                hintText: '(OPTIONAL) REFERRAL CODE'),
            controller: referralController,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              style: _textStyle,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              controller: password,
              validator: nullValidator,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true),
        ],
      ),
    );
  }

  TextStyle get _textStyle => const TextStyle(
        fontSize: 16,
      );
}
