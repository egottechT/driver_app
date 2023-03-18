import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/review_trip_screen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final Map map;
  const PaymentScreen({Key? key,required this.map}) : super(key: key);

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
        const SizedBox(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
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
                          cardViewLayout("Rs. ${widget.map["price"]}", "TOTAL FARE"),
                          cardViewLayout("${widget.map["distance"] ?? "--"} km", "TOTAL DISTANCE"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55),
                        child: Text("${widget.map["title"]} to Pay in Cash",
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: locationAddress(),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: fareCollectionCard(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ReviewTripScreen(map: widget.map)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text("CASH COLLECTED",style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }

  Widget addressWithIcon(Icon icon, String address) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),
        Flexible(
            child: Text(
          address,
          style: const TextStyle(overflow: TextOverflow.clip),
        ))
      ],
    );
  }

  locationAddress() {

    String pickUp = widget.map["pick-up"]["location"];
    String destination = widget.map["destination"]["location"];
    return Column(
      children: [
        addressWithIcon(
            const Icon(
              Icons.circle_outlined,
              color: Colors.green,
            ),
            pickUp),
        const SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.grey[200],
          height: 5,
          thickness: 2,
        ),
        const SizedBox(
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
        const SizedBox(height: 5,),
        Divider(
          color: secondaryColor,
          height: 5,
          thickness: 2,
        ),
        const SizedBox(height: 5,),
      ],
    );
  }

  fareCollectionCard() {
    return Column(
      children: [
        fareEntryView("Trip fare", "Rs. ${widget.map["price"]}"),
        fareEntryView("Tolls", "Rs.00.00"),
        fareEntryView("Rider discounts", "Rs. 0.00"),
        fareEntryView("Outstanding from last trip", "Rs. 00.00"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(color: secondaryColor,fontWeight: FontWeight.bold),
            ),
            Text(
              "Rs. ${widget.map["price"]}",
              style: TextStyle(color: secondaryColor,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
