import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Widget cardViewLayout(String value, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
              color: secondaryColor, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Text(title, style: TextStyle(color: secondaryColor, fontSize: 12))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text("Collect Cash", style: TextStyle(color: secondaryColor)),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cardViewLayout("Rs. 120", "TOTAL FARE"),
                      cardViewLayout("3.5 km", "TOTAL DISTANCE"),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 55),
                    child: Text("Mr. Raj to Pay in Cash",
                        style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: locationAddress(),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: fareCollectionCard(),
                  ),
                ),ElevatedButton(
                  onPressed: (){

                  },
                  child: Text("CASH COLLECTED",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget addressWithIcon(Icon icon, String address) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(
          width: 5,
        ),
        Flexible(
            child: Text(
          address,
          style: TextStyle(overflow: TextOverflow.clip),
        ))
      ],
    );
  }

  locationAddress() {
    String pickUp = "Lower Nehrugram, Dehradun, 248001, Uttarakhand, India";
    String destination = "Mohkampur, Dehradun, 248001, Uttarakhand, India";
    return Column(
      children: [
        addressWithIcon(
            Icon(
              Icons.circle_outlined,
              color: Colors.green,
            ),
            pickUp),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.grey[200],
          height: 5,
          thickness: 2,
        ),
        SizedBox(
          height: 10,
        ),
        addressWithIcon(
            Icon(
              Icons.location_on,
              color: secondaryColor,
            ),
            destination),
      ],
    );
  }

  fareEntryView(String title, String price) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
            ),
            Text(price),
          ],
        ),
        SizedBox(height: 5,),
        Divider(
          color: secondaryColor,
          height: 5,
          thickness: 2,
        ),
        SizedBox(height: 5,),
      ],
    );
  }

  fareCollectionCard() {
    return Column(
      children: [
        fareEntryView("Trip fare", "Rs. 100.00"),
        fareEntryView("Tolls", "Rs. 10.00"),
        fareEntryView("Rider discounts", "Rs. 0.00"),
        fareEntryView("Outstanding from last trip", "Rs. 10.00"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(color: secondaryColor,fontWeight: FontWeight.bold),
            ),
            Text(
              "Rs. 120.00",
              style: TextStyle(color: secondaryColor,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
