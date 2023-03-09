import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/setting_screens/payment_screen.dart';
import 'package:driver_app/screens/pickup_screens/pick_otp_check.dart';
import 'package:flutter/material.dart';

Widget bottomPanelLayout(Map map,BuildContext context,bool isPickup) {
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
                  children: [
                    const Text("Customer Details",style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text(map["title"] ?? ""),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Call to Customer",style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text(map["phoneNumber"] ?? ""),
                  ],
                )
              ],
            )),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: (){
            if(isPickup) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PickOtpScreen(map: map)));
            }
            else{
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PaymentScreen(map: map)));
              context.showErrorSnackBar(message: "Working on this sir");
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: Text(
            isPickup ? "Continue" : "End Trip",
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
    ),
  );
}
