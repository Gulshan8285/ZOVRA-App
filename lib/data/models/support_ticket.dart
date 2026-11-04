class SupportTicket {
  final String id;
  final String ticketNumber;
  final String userId;
  final String category; // 'Booking', 'Payment', 'Service Quality', 'Refund', 'Other'
  final String subject;
  final String message;
  final String status; // 'Open', 'In Review', 'Resolved'
  final DateTime createdAt;
  final String? bookingId;
  final String? responseMessage;

  SupportTicket({
    required this.id,
    required this.ticketNumber,
    required this.userId,
    required this.category,
    required this.subject,
    required this.message,
    this.status = 'Open',
    DateTime? createdAt,
    this.bookingId,
    this.responseMessage,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'userId': userId,
      'category': category,
      'subject': subject,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'bookingId': bookingId,
      'responseMessage': responseMessage,
    };
  }

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] as String,
      ticketNumber: json['ticketNumber'] as String,
      userId: json['userId'] as String,
      category: json['category'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      status: json['status'] as String? ?? 'Open',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      bookingId: json['bookingId'] as String?,
      responseMessage: json['responseMessage'] as String?,
    );
  }
}

