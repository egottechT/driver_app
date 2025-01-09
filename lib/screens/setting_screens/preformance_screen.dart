import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/Utils/name_and_function.dart';
import 'package:driver_app/widgets/elevated_button_style.dart';
import 'package:flutter/material.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  List<Pair<String, Icon>> items = [
    Pair(
        "Your Balance Details",
        Icon(
          Icons.storefront_outlined,
          color: secondaryColor,
        )),
    Pair(
        "Booking History & Earning Details",
        Icon(
          Icons.book_outlined,
          color: secondaryColor,
        )),
    Pair(
        "Refer and Earn",
        Icon(
          Icons.group,
          color: secondaryColor,
        )),
    Pair(
        "Rewards and Incentives",
        Icon(
          Icons.stacked_line_chart_rounded,
          color: secondaryColor,
        )),
    Pair(
        "Contact Partner Support,If any Query?",
        Icon(
          Icons.call,
          color: secondaryColor,
        )),
  ];
  late List<dynamic> functionList;

  @override
  void initState() {
    super.initState();
    functionList = getFunctionList(context);
  }

  spaceBetweenWidget({double height = 10}) {
    return SizedBox(
      height: height,
    );
  }

  Widget firstCardView() {
    DateTime now = DateTime.now();
    String dateOnly = now.getDateOnly();

    return Card(
      color: secondaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              "Today $dateOnly",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            spaceBetweenWidget(),
            const Text(
              "Rs. 30,000/-",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            spaceBetweenWidget(),
            const Text(
              "10 Rides completed",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Performance",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              firstCardView(),
              spaceBetweenWidget(height: 20),
              secondCardView(),
              spaceBetweenWidget(height: 30),
              ListView.builder(
                itemBuilder: (context, index) {
                  return cardViewWithText(items[index].first,
                      functionList[index], items[index].last);
                },
                shrinkWrap: true,
                primary: false,
                itemCount: items.length,
              )
            ],
          ),
        ),
      ),
    );
  }

  secondCardView() {
    int price = 1230;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Text(
                  "Your balance manage here, you can take more rides/trips to automatically make a payment",
                  style: TextStyle(
                      overflow: TextOverflow.clip, color: secondaryColor),
                )),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                  elevatedButtonStyle(backgroundColor: secondaryColor),
                  child: Text("Pay ₹$price"),
                )),
          ],
        ),
      ),
    );
  }

  Widget cardViewWithText(String title, dynamic onTap, Icon icon) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          child: ListTile(
            leading: Icon(
              Icons.keyboard_arrow_right,
              color: secondaryColor,
            ),
            title: Text(
              title,
              style: TextStyle(color: secondaryColor),
            ),
            trailing: icon,
          ),
        ));
  }
}
