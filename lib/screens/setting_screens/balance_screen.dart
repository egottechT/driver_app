import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  String moneyText = "Rs. 500";
  bool showCardView = true;
  Color? lightGrey = Colors.grey[200];

  Widget currentBalance() {
    return Card(
      shape: const RoundedRectangleBorder(
        //<-- SEE HERE
        side: BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
      color: lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Current Balance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(moneyText),
                const Text(
                  "ADD ETAXI Money",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget serviceRowListItem(Icon icon, String title) {
    return Card(
      color: lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            icon,
            Text(
              title,
              style: TextStyle(fontSize: 10, color: secondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        const Text(
          "  Service",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
        ),
        const SizedBox(height: 10,),
        Card(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: serviceRowListItem(
                      Icon(Icons.money, color: secondaryColor), "Pay"),
                ),
                Expanded(
                  flex: 1,
                  child: serviceRowListItem(
                      Icon(Icons.send_outlined, color: secondaryColor), "Send Money"),
                ),
                Expanded(
                  flex: 1,
                  child: serviceRowListItem(Icon(Icons.receipt_long, color: secondaryColor),
                      "Bill payment"),
                ),
                Expanded(
                  flex: 1,
                  child: serviceRowListItem(
                      Icon(
                        Icons.history,
                        color: secondaryColor,
                      ),
                      "History"),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget lastActivity() {
    return Card(
      color: lightGrey,
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Activity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ETaxi"),
                Text(
                  "60.72",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Other"),
                Text(
                  "-20.21",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget cashbackView() {
    return Visibility(
      visible: showCardView,
      child: Card(
        color: lightGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Cashback & Discounts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        showCardView = false;
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: primaryColor,
                      )),
                ],
              ),
              Text(
                "Make your money go step up",
                style: TextStyle(
                  color: primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addressList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.home,
              color: secondaryColor,
            ),
            label: const Text(
              "ADD YOUR HOME ADDRESS",
              style: TextStyle(color: Colors.black,),
            ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0
              )
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.warehouse_rounded,
              color: secondaryColor,
            ),
            label: const Text(
              "ADD YOUR WORK/OFFICE ADDRESS",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black),
            ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                elevation: 0
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BOOK MY ETAXI Money"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Column(
            children: [
              Image.asset("assets/images/permission_page.png"),
              currentBalance(),
              serviceList(),
              lastActivity(),
              cashbackView(),
              addressList(),
            ],
          ),
        ),
      ),
    );
  }
}
