import 'package:driver_app/Utils/constants.dart';
import 'package:driver_app/model/user_model.dart';
import 'package:driver_app/provider/user_provider.dart';
import 'package:driver_app/repository/driver_repo.dart';
import 'package:driver_app/repository/transaction_repo.dart';
import 'package:driver_app/widgets/elevated_button_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: moneyController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      labelText: 'Money',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: elevatedButtonStyle(backgroundColor: secondaryColor),
                    onPressed: () async {
                      // Add action for the next button

                      UserModel model =
                          Provider.of<UserModelProvider>(context, listen: false)
                              .data;

                      int transferAmount = int.parse(moneyController.text);

                      String phoneNumber = "+91${phoneController.text}";
                      if (model.phoneNumber == phoneNumber) {
                        context.showErrorSnackBar(
                            message: 'Cannot Send to your own phone number');
                        return;
                      }
                      if (model.amount < transferAmount) {
                        context.showErrorSnackBar(
                            message:
                                'You don\'t have enough money to send this amount to other driver');
                        return;
                      }

                      String uuid = await DriverRepo()
                          .getDriverUuidByPhoneNumber(phoneNumber);
                      if (uuid == 'No driver match') {
                        context.showErrorSnackBar(
                            message:
                                'No driver is available with this phone number');
                        return;
                      }
                      await TransactionRepo().updateDriverAmount(
                          uuid, transferAmount, 'Money Received', true);

                      await TransactionRepo().updateDriverAmount(
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                          -1 * transferAmount,
                          'Money Sent',
                          false);

                      model.amount -= transferAmount;

                      setState(() {
                        isLoading = true;
                      });

                      Provider.of<UserModelProvider>(context, listen: false)
                          .setData(model);
                      Navigator.of(context).pop();
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
      ),
    );
  }
}
