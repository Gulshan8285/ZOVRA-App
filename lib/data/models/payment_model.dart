class PaymentTransaction {
  final String id;
  final String bookingId;
  final double amount;
  final String paymentMethod; // 'UPI', 'Google Pay', 'Credit/Debit Card', 'Net Banking', 'COD'
  final String status; // 'Success', 'Failed', 'Refunded'
  final String transactionId;
  final DateTime timestamp;

  PaymentTransaction({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.transactionId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}

