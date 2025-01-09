import 'package:driver_app/model/transaction_model.dart';
import 'package:driver_app/repository/transaction_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<TransactionModel> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchtransactionData();
  }

  void fetchtransactionData() async {
    List<TransactionModel> data = [];
    data = await TransactionRepo().fetchDriverTransactions();
    setState(() {
      list = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            TransactionModel model = list[index];

            return Card(
              color: Colors.grey[300],
              child: ListTile(
                leading: Icon(model.isAdded ? Icons.add : Icons.minimize,
                    color: model.isAdded ? Colors.green : Colors.red),
                title: Text(model.status),
                subtitle: Text(formatDate(model.date)),
                trailing: Text(
                  "Rs. ${model.amount.toString()}",
                  style: TextStyle(
                      color: model.isAdded ? Colors.green : Colors.red),
                ),
              ),
            );
          }),
    );
  }

  String formatDate(String data) {
    try {
      // Parse the date string to a DateTime object
      DateTime dateTime = DateTime.parse(data);

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat("hh:mm a dd/MM/yyyy").format(dateTime);

      return formattedDate;
    } catch (e) {
      print("Error formatting date: ${e.toString()}");
      return "Invalid Date";
    }
  }
}
