class ReviewModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final List<String> tags;
  final List<String> photos;
  final DateTime createdAt;
  final bool isVerifiedBooking;
  final int helpfulCount;

  ReviewModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.rating,
    required this.comment,
    this.tags = const [],
    this.photos = const [],
    DateTime? createdAt,
    this.isVerifiedBooking = true,
    this.helpfulCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'isVerifiedBooking': isVerifiedBooking,
      'helpfulCount': helpfulCount,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String? ?? '',
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String? ?? '',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isVerifiedBooking: json['isVerifiedBooking'] as bool? ?? true,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
    );
  }
}

