import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/screens/common_widget.dart';
import 'package:driver_app/service/database.dart';
import 'package:driver_app/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewTripScreen extends StatefulWidget {
  final Map map;

  const ReviewTripScreen({Key? key, required this.map}) : super(key: key);

  @override
  State<ReviewTripScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewTripScreen> {
  TextEditingController textEditingController = TextEditingController();
  double star = 0;

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
                  tripDetailCardView(
                      "Rs. ${widget.map["price"]}", "Total Fare"),
                  tripDetailCardView(
                      "${widget.map["distance"]} KM", "Total Distance"),
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
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("${widget.map["title"]}"),
                      trailing: Column(
                        children: [
                          Text("${widget.map["price"]}"),
                          const Text("Cash"),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        editableRatingBar(onStarChange),
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
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          child: const Text(
                            "NEED HELP?",
                            style: TextStyle(color: Colors.black),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            uploadRatingUser(
                                widget.map,
                                star,
                                textEditingController.text,
                                Provider.of<UserModelProvider>(context,
                                        listen: false)
                                    .data
                                    .name);
                            LocalNoticeService.sendNotification = true;
                            Navigator.popUntil(context,
                                ModalRoute.withName('/managementScreen'));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
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

  void onStarChange(value) {
    star = value;
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
