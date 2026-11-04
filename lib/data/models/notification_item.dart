class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type; // 'booking', 'offer', 'system'
  final DateTime createdAt;
  final bool isRead;
  final String? bookingId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    DateTime? createdAt,
    this.isRead = false,
    this.bookingId,
  }) : createdAt = createdAt ?? DateTime.now();

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    DateTime? createdAt,
    bool? isRead,
    String? bookingId,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      bookingId: bookingId ?? this.bookingId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'bookingId': bookingId,
    };
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String? ?? 'system',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      bookingId: json['bookingId'] as String?,
    );
  }
}

