import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/screens/common_widget.dart';
import 'package:flutter/material.dart';

class ReviewTripScreen extends StatefulWidget {
  const ReviewTripScreen({Key? key}) : super(key: key);

  @override
  State<ReviewTripScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewTripScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review your trip"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: primaryColor,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  tripDetailCardView("Rs. 12", "Total Fare"),
                  tripDetailCardView("4.5 KM", "Total Distance"),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Jessica Fox"),
                      subtitle: Text("05:35 PM"),
                      trailing: Column(
                        children: [
                          Text("Rs. 85"),
                          Text("Cash"),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        editableRatingBar(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                                labelText: "Write Your Review",
                                focusColor: Colors.grey),
                            controller: textEditingController,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: const Text(
                            "NEED HELP?",
                            style: TextStyle(color: Colors.black),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(context, ModalRoute.withName('/managementScreen'));
                          },
                          style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.black),
                          child: const Text(
                            "RATE NOW",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  tripDetailCardView(String value, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 25, color: secondaryColor),
        ),
        Text(title, style: TextStyle(color: secondaryColor))
      ],
    );
  }
}
