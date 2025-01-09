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
    fetchTransactionData();
  }

  void fetchTransactionData() async {
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
            Color color = model.isAdded ? Colors.green : Colors.red;

            return Card(
              color: Colors.grey[300],
              child: ListTile(
                leading: Icon(
                  model.isAdded ? Icons.add : Icons.minimize,
                  color: color,
                ),
                title: Text(model.status),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align text to the start
                  children: [
                    Text(formatDate(model.date)),
                    // Original subtitle
                    SizedBox(height: 4),
                    Text(
                      "Order-ID: ${model.orderID}",
                      // Second additional field
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      "Avl. Balance: ${model.currentBalance}",
                      // First additional field
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    Text(
                      "Name:- ${model.userName}",
                      // Third additional field
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                trailing: Text(
                  "Rs. ${model.amount.toString()}",
                  style: TextStyle(color: color),
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
