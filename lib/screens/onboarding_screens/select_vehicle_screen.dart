import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class SelectVehicleScreen extends StatefulWidget {
  const SelectVehicleScreen({Key? key}) : super(key: key);

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  late String miniDesp, microDesp, primeDesp;
  bool clicked = false;
  int clickedIndex = -1;
  String showText = "";

  @override
  void initState() {
    super.initState();
    miniDesp =
        "You are a commercially insured driver.Your vehicle is a mid-size or full size vehicle that comfortably seats 4 passangers or more.";
    primeDesp = miniDesp;
    microDesp = miniDesp;
  }

  Widget conditionCheckForVehicle(int index) {
    if (clickedIndex == index) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(child: Text(showText)),
              const SizedBox(
                width: 10,
              ),
              Image.asset("assets/icons/person.png")
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget vehicleCardView(int index) {
    late String name;
    late Image carIcon;
    if (index == 0) {
      name = "Micro";
      carIcon = Image.asset("assets/icons/micro_car.png");
    } else if (index == 1) {
      name = "ETaxi Mini Share";
      carIcon = Image.asset("assets/icons/mini_car.png");
    } else {
      name = "Prime Sedan";
      carIcon = Image.asset("assets/icons/prime_car.png");
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              leading: carIcon,
              trailing: (clicked && (clickedIndex == index))
                  ? Image.asset("assets/icons/tick.png")
                  : const SizedBox(
                      width: 2,
                    ),
            ),
            clicked ? conditionCheckForVehicle(index) : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Select Vehicle type",
            style: TextStyle(color: Colors.black),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("PLEASE CHOOSE HOW YOU WOULD LIKE TO",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              const SizedBox(
                height: 15,
              ),
              const Text.rich(TextSpan(children: [
                TextSpan(
                    text: "PARTNER WITH ",
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: "BOOK MY ETAXI",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))
              ])),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        clicked = !clicked;
                        clickedIndex = index;
                        if (index == 0) {
                          showText = microDesp;
                        } else if (index == 1) {
                          showText = miniDesp;
                        } else {
                          showText = primeDesp;
                        }
                      });
                    },
                    child: vehicleCardView(index),
                  );
                },
                itemCount: 3,
              ),
              const SizedBox(height: 200,),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text("CONTINUE"),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
