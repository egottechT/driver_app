import 'package:driver_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Wallet",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: primaryColor,
            height: 200,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("₹ 502.00",style: TextStyle(fontSize: 25,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text("Total Earn"),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("PAYMENT HISTORY"),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 10,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return const ListTile(
                    leading: Icon(Icons.currency_rupee),
                    title: Text("Aryan BIsht"),
                    subtitle: Text("#jkasdfjal"),
                    trailing: Text("₹ 50"),
                  );
                },
                shrinkWrap: true,
            ),
          ),
              ))
        ],
      ),
    );
  }
}
