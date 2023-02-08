import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

Widget bottomPanelLayout() {
  return Container(
    color: Colors.grey[200],
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Pick-up",
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        Container(
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: secondaryColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/images/car.png"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Customer Details",style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text("Mr. Abhay Sati"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Call to Customer",style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text("9458942703"),
                  ],
                )
              ],
            )),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    ),
  );
}
