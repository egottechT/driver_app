import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help & Support",
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topCardViews(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: bottomCardView(),
            ),
          ],
        ),
      ),
    );
  }

  topCardViews() {
    return Container(
        color: secondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardItemView(
                      "App is not working?",
                      const Icon(
                        Icons.phone_android_rounded,
                        size: 40,
                      )),
                  cardItemView(
                      "Status of my city",
                      const Icon(
                        Icons.location_city_sharp,
                        size: 40,
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardItemView(
                      "Safety Zone",
                      const Icon(
                        Icons.health_and_safety_outlined,
                        size: 40,
                      )),
                  cardItemView(
                      "Emergency Response\nService",
                      const Icon(
                        Icons.local_police_rounded,
                        size: 40,
                      )),
                ],
              ),
            ],
          ),
        ));
  }

  cardItemView(String title, Icon icon) {
    return Container(
      width: 160,
      height: 100,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                Text(
                  title,
                  style: TextStyle(color: secondaryColor),
                )
              ],
            ),
            icon
          ],
        ),
      ),
    );
  }

  bottomCardView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Need help & Support with your rides?",
          style: TextStyle(color: secondaryColor, fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        carDetailCardView(),
        lastCardView(),
      ],
    );
  }

  lastCardView() {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
        title: Text(
          "View last Rides Details",
          style: TextStyle(color: secondaryColor),
        ),
      ),
    );
  }

  carDetailCardView() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            carDetailRow(),
            const Text(
              "SEP 16,2023",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                detailSectionOfRid("Distance", "Time Status", "10.00 Km"),
                detailSectionOfRid("Ride", "Time", "11.00 AM"),
                detailSectionOfRid("Admin", "Bill Details", "Rs. 400"),
              ],
            )
          ],
        ),
      ),
    );
  }

  carDetailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "CNR: 6353511376",
          style: TextStyle(
              color: secondaryColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const Icon(Icons.car_rental_outlined),
            Text(
              "Mini Share",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  detailSectionOfRid(String title, String name, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(name),
        const SizedBox(
          height: 5,
        ),
        Text(value),
      ],
    );
  }
}
