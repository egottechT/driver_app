import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/screens/setting_screens/car_details_screens/select_vehicle_screen.dart';
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
  String state = "None";
  String franchise = "None";

  String? nullValidator(dynamic value) {
    if (value == null || value!.isEmpty) {
      return "Some value is required";
    }
    return null;
  }

  String? dropDownValidator(dynamic value) {
    if (value == null || value!.isEmpty) {
      return "Some value is required";
    }
    // if (value! == "None") return "Please select any other option";
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
                            style:
                                TextStyle(color: secondaryColor, fontSize: 16),
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
                          UserModel model = UserModel();
                          model.name = "${firstName.text} ${lastName.text}";
                          model.phoneNumber = phoneNumber.text;
                          model.state = state;
                          model.franchise = franchise;
                          User? result = FirebaseAuth.instance.currentUser;
                          DatabaseUtils().addUserToDatabase(
                              result?.uid.toString() as String, model);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SelectVehicleScreen(
                                    isFromStart: true,
                                  )));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text("Next"),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget registrationForm() {
    // firstName.text = "Aryan";
    // lastName.text = "Bisht";
    // phoneNumber.text = "9068616413";
    // state = "None";
    // franchise = "None";
    // password.text = "lasjdfl";

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
          FutureBuilder(
              future: fetchCityDealerData(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pair<String, String>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Display a progress indicator while loading
                }
                List<Pair<String, String>> cityDealer = [];
                if (snapshot.connectionState == ConnectionState.done) {
                  cityDealer = snapshot.data ?? [];
                }
                cityDealer.add(Pair("None", "None"));
                return DropdownButtonFormField(
                  value: state,
                  items: List.generate(
                    cityDealer.length,
                    (index) => DropdownMenuItem(
                      value: cityDealer[index].last,
                      child: Text(cityDealer[index].first),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        state = val;
                        franchise = "None";
                      });
                      debugPrint(state);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'State You Drive',
                  ),
                  validator: dropDownValidator,
                );
              }),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: fetchData(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pair<String, String>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Display a progress indicator while loading
                }
                List<Pair<String, String>> franchiseList = [];
                if (snapshot.connectionState == ConnectionState.done) {
                  franchiseList = snapshot.data ?? [];
                }
                franchiseList.add(Pair("None", "None"));
                return DropdownButtonFormField(
                  value: franchise,
                  items: List.generate(
                    franchiseList.length,
                    (index) => DropdownMenuItem(
                      value: franchiseList[index].last,
                      child: Text(franchiseList[index].first),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        franchise = val;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Your Franchise',
                  ),
                  validator: dropDownValidator,
                );
              }),
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

  Future<List<Pair<String, String>>> fetchData() async {
    // Simulate an asynchronous operation
    List<Pair<String, String>> list = await DatabaseUtils().getFranchiseData(state);
    return list;
  }

  Future<List<Pair<String, String>>> fetchCityDealerData() async {
    List<Pair<String, String>> list = await DatabaseUtils().getCityDealerData();
    return list;
  }
}
