import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/repository/transaction_repo.dart';
import 'package:driver_app/repository/user_repo.dart';
import 'package:driver_app/screens/common_widget.dart';
import 'package:driver_app/service/notification_service.dart';
import 'package:driver_app/widgets/elevated_button_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewTripScreen extends StatefulWidget {
  final Map map;

  const ReviewTripScreen({super.key, required this.map});

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
                          onPressed: onPressed,
                          style: elevatedButtonStyle(
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

  void onPressed() {
    UserRepo().uploadRatingUser(widget.map, star, textEditingController.text,
        Provider.of<UserModelProvider>(context, listen: false).data.name);

    int rechargeValue = int.parse(widget.map["price"]).round();
    rechargeValue = (0.1 * rechargeValue).round();
    TransactionRepo().updateDriverAmount(
        FirebaseAuth.instance.currentUser!.uid.toString(),
        -1 * rechargeValue,
        'Ride Accepted',
        false);

    UserModel model =
        Provider.of<UserModelProvider>(context, listen: false).data;

    model.amount -= rechargeValue;

    Provider.of<UserModelProvider>(context, listen: false).setData(model);

    LocalNoticeService.sendNotification = true;
    Navigator.popUntil(context, ModalRoute.withName('/managementScreen'));
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
