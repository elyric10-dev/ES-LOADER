class Inventory {
  int? id;
  int currentBalance;
  String mobileNumber;
  int deductBalance;
  int fee;
  int totalProfit;
  int newBalance;
  int inserted;
  int numberBalance;
  DateTime timestamp;
  String transactionId;
  int hasEnquired;
  int enquiryFixed;

  Inventory({
    this.id,
    required this.currentBalance,
    required this.mobileNumber,
    required this.deductBalance,
    required this.fee,
    required this.totalProfit,
    required this.newBalance,
    required this.inserted,
    required this.numberBalance,
    required this.timestamp,
    required this.transactionId,
    required this.hasEnquired,
    required this.enquiryFixed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'current_gcash_balance': currentBalance,
      'mobile_number': mobileNumber,
      'deduct_balance': deductBalance,
      'fee': fee,
      'total_profit': totalProfit,
      'new_gcash_balance': newBalance,
      'inserted': inserted,
      'number_balance': numberBalance,
      'timestamp': timestamp.toIso8601String(),
      'transaction_id': transactionId,
      'has_enquired': hasEnquired,
      'enquire_fixed': enquiryFixed,
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      id: map['id'],
      currentBalance: map['current_gcash_balance'],
      mobileNumber: map['mobile_number'],
      deductBalance: map['deduct_balance'],
      fee: map['fee'],
      totalProfit: map['total_profit'],
      newBalance: map['new_gcash_balance'],
      inserted: map['inserted'],
      numberBalance: map['number_balance'],
      timestamp: DateTime.parse(map['timestamp']),
      transactionId: map['transaction_id'],
      hasEnquired: map['has_enquired'],
      enquiryFixed: map['enquire_fixed'],
    );
  }
}
