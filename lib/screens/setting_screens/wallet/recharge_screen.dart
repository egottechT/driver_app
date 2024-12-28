import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/service/razor_pay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  String enteredAmount = '';

  void _onKeyboardTap(String value) {
    setState(() {
      if (value == 'DEL') {
        if (enteredAmount.isNotEmpty) {
          enteredAmount = enteredAmount.substring(0, enteredAmount.length - 1);
        }
      } else {
        enteredAmount += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Enter Amount'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display area
          SizedBox(
            height: 150,
          ),
          Text('Enter the amount you want to Recharge'),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              enteredAmount.isEmpty ? '₹0' : '₹$enteredAmount',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Custom keyboard
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (int i = 0; i < 4; i++)
                    Row(
                      children: List.generate(3, (j) {
                        String value = '';
                        if (i == 3 && j == 1) {
                          value = '0';
                        } else if (i == 3 && j == 2) {
                          value = 'DEL';
                        } else if (i == 3 && j == 0)
                          value = '';
                        else if (i != 3 || j == 0) {
                          value = ((i * 3) + j + 1).toString();
                        }

                        return Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextButton(
                              onPressed: value.isNotEmpty
                                  ? () => _onKeyboardTap(value)
                                  : null,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: value == 'DEL'
                                      ? Colors.red
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
          ),

          // Recharge Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Handle recharge action
                  print("Recharge with amount: ₹$enteredAmount");
                  RazorPayService().initRazorPay();
                  await RazorPayService().createOrder(enteredAmount);
                  if (RazorPayService.paymentSuccess) {
                    debugPrint('Payment Success');
                    UserModel model =
                        Provider.of<UserModelProvider>(context, listen: false)
                            .data;

                    model.amount += int.parse(enteredAmount);
                    Provider.of<UserModelProvider>(context, listen: false)
                        .setData(model);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Recharge',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
