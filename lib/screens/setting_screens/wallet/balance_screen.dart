import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/screens/setting_screens/wallet/recharge_screen.dart';
import 'package:driver_app/screens/setting_screens/wallet/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  String moneyText = "Rs. 500";
  bool showCardView = true;
  Color? lightGrey = Colors.grey[200];

  @override
  void initState() {
    super.initState();
    fetchDriverData();
  }

  Widget currentBalance() {
    return Card(
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
      color: lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Current Balance :- ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              moneyText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green),
            )
          ],
        ),
      ),
    );
  }

  Widget serviceRowListItem(Icon icon, String title, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
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
      ),
    );
  }

  Widget serviceList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          "  Service",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
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
                      Icon(Icons.send_outlined, color: secondaryColor),
                      "Send Money",
                      () {
                        
                      }),
                ),
                Expanded(
                  flex: 1,
                  child: serviceRowListItem(
                      Icon(Icons.receipt_long, color: secondaryColor),
                      "Recharge", () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RechargeScreen()));
                  }),
                ),
                Expanded(
                  flex: 1,
                  child: serviceRowListItem(
                      Icon(
                        Icons.history,
                        color: secondaryColor,
                      ),
                      "History", () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const TransactionHistoryScreen()));
                  }),
                ),
              ],
            ),
          ),
        )
      ],
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
              SizedBox(
                height: 25,
              ),
              currentBalance(),
              serviceList(),
            ],
          ),
        ),
      ),
    );
  }

  void fetchDriverData() {
    UserModel model =
        Provider.of<UserModelProvider>(context, listen: false).data;
    setState(() {
      moneyText = "Rs. ${model.amount.toString()}";
    });
  }
}
