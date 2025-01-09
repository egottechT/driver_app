import 'package:driver_app/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TransactionRepo {
  Future<void> updateDriverAmount(String uuid, int incrementBy, String status,
      bool isAdded, String orderId, String userName) async {
    try {
      if (uuid.isEmpty) return;
      final DatabaseReference driverRef =
          FirebaseDatabase.instance.ref("driver/$uuid");

      final DataSnapshot snapshot = await driverRef.get();

      if (snapshot.exists) {
        final Map<dynamic, dynamic>? driverData =
            snapshot.value as Map<dynamic, dynamic>?;
        int currentAmount = driverData?['amount'] ?? 0;

        await driverRef.update({'amount': currentAmount + incrementBy});
        final DatabaseReference transactionRef =
            driverRef.child("transaction").push();

        String orderIdKey =
            orderId + (transactionRef.key?.substring(0, 6) ?? "");

        await transactionRef.set({
          "amount": incrementBy.abs(),
          "status": status,
          "is_added": isAdded,
          "date": DateTime.now().toString(),
          "order_id": orderIdKey,
          "current_balance": currentAmount + incrementBy,
          "user_name": userName
        });
      } else {
        print("Driver with UUID $uuid not found.");
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  Future<List<TransactionModel>> fetchDriverTransactions() async {
    try {
      String uuid = FirebaseAuth.instance.currentUser!.uid.toString();
      // Reference to the driver's transaction node
      final DatabaseReference transactionRef =
          FirebaseDatabase.instance.ref("driver/$uuid/transaction");

      // Fetch the transaction data from Firebase
      final DataSnapshot snapshot = await transactionRef.get();

      // Initialize an empty list to store transactions
      List<TransactionModel> transactions = [];

      if (snapshot.exists) {
        final Map<dynamic, dynamic>? transactionsData =
            snapshot.value as Map<dynamic, dynamic>?;

        // Convert each transaction entry to a TransactionModel model
        if (transactionsData != null) {
          transactions = transactionsData.values.map((entry) {
            final Map<String, dynamic> transactionJson =
                Map<String, dynamic>.from(entry);
            return TransactionModel.fromJson(transactionJson);
          }).toList();
        }
      }

      transactions.sort((a, b) {
        DateTime dateA = DateTime.parse(a.date);
        DateTime dateB = DateTime.parse(b.date);

        return dateB.compareTo(dateA);
      });
      return transactions;
    } catch (e) {
      // Handle any errors that occur
      print("Error fetching transactions: ${e.toString()}");
      return [];
    }
  }
}
