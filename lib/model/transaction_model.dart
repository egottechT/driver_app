class TransactionModel {
  final int amount;
  final String status;
  final bool isAdded;
  final String date;
  final String orderID;
  final int currentBalance;
  final String userName;

  TransactionModel({
    required this.amount,
    required this.status,
    required this.isAdded,
    required this.date,
    required this.orderID,
    required this.currentBalance,
    required this.userName,
  });

  // Factory constructor to create an instance from a JSON object
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      amount: json['amount'] as int,
      status: json['status'] as String,
      isAdded: json['is_added'] as bool,
      date: json['date'] as String,
      orderID: json['order_id'] ?? "",
      currentBalance: json['current_balance'] ?? 0,
      userName: json['user_name'] ?? "No name",
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'status': status,
      'is_added': isAdded,
      'date': date,
    };
  }
}
