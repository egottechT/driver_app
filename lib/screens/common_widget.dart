import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

Widget firstCardView(String name, String title) {
  return Card(
      elevation: 0,
      color: Colors.grey[300],
      child: Row(
        children: [
          Column(children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset("assets/images/profile.png")
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                title,
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
