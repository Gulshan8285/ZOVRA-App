import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'address_model.dart';
import 'cart_item.dart';

enum BookingStatus {
  pending,
  confirmed,
  partnerAssigned,
  onTheWay,
  inProgress,
  completed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.partnerAssigned:
        return 'Partner Assigned';
      case BookingStatus.onTheWay:
        return 'Partner On The Way';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return AppColors.info;
      case BookingStatus.partnerAssigned:
        return const Color(0xFF6366F1); // Indigo
      case BookingStatus.onTheWay:
        return AppColors.primary;
      case BookingStatus.inProgress:
        return const Color(0xFF8B5CF6); // Purple
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  int get stepIndex {
    switch (this) {
      case BookingStatus.pending:
        return 0;
      case BookingStatus.confirmed:
        return 1;
      case BookingStatus.partnerAssigned:
        return 2;
      case BookingStatus.onTheWay:
        return 3;
      case BookingStatus.inProgress:
        return 4;
      case BookingStatus.completed:
        return 5;
      case BookingStatus.cancelled:
        return -1;
    }
  }
}

class BookingModel {
  final String id; // e.g. "ZOV-2026-8941"
  final String userId;
  final List<CartItem> items;
  final DateTime scheduledDate;
  final String timeSlot;
  final AddressModel address;
  final BookingStatus status;
  final String partnerName;
  final String partnerPhone;
  final String partnerAvatar;
  final double partnerRating;
  final double subtotal;
  final double serviceDiscount;
  final double couponDiscount;
  final String? couponCode;
  final double taxAmount;
  final double platformFee;
  final double totalAmount;
  final String paymentMethod; // UPI, Card, NetBanking, COD
  final String paymentStatus; // Paid, Pending, Refunded
  final String transactionId;
  final String? cancellationReason;
  final DateTime createdAt;
  final bool isReviewed;

  BookingModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.status,
    this.partnerName = 'Rahul Sharma',
    this.partnerPhone = '+91 98110 54321',
    this.partnerAvatar =
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
    this.partnerRating = 4.9,
    required this.subtotal,
    this.serviceDiscount = 0.0,
    this.couponDiscount = 0.0,
    this.couponCode,
    required this.taxAmount,
    required this.platformFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    this.cancellationReason,
    DateTime? createdAt,
    this.isReviewed = false,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get canBeCancelled {
    return status != BookingStatus.completed &&
        status != BookingStatus.cancelled &&
        status != BookingStatus.inProgress;
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    DateTime? scheduledDate,
    String? timeSlot,
    AddressModel? address,
    BookingStatus? status,
    String? partnerName,
    String? partnerPhone,
    String? partnerAvatar,
    double? partnerRating,
    double? subtotal,
    double? serviceDiscount,
    double? couponDiscount,
    String? couponCode,
    double? taxAmount,
    double? platformFee,
    double? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? transactionId,
    String? cancellationReason,
    DateTime? createdAt,
    bool? isReviewed,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      address: address ?? this.address,
      status: status ?? this.status,
      partnerName: partnerName ?? this.partnerName,
      partnerPhone: partnerPhone ?? this.partnerPhone,
      partnerAvatar: partnerAvatar ?? this.partnerAvatar,
      partnerRating: partnerRating ?? this.partnerRating,
      subtotal: subtotal ?? this.subtotal,
      serviceDiscount: serviceDiscount ?? this.serviceDiscount,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      couponCode: couponCode ?? this.couponCode,
      taxAmount: taxAmount ?? this.taxAmount,
      platformFee: platformFee ?? this.platformFee,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((i) => i.toJson()).toList(),
      'scheduledDate': scheduledDate.toIso8601String(),
      'timeSlot': timeSlot,
      'address': address.toJson(),
      'status': status.name,
      'partnerName': partnerName,
      'partnerPhone': partnerPhone,
      'partnerAvatar': partnerAvatar,
      'partnerRating': partnerRating,
      'subtotal': subtotal,
      'serviceDiscount': serviceDiscount,
      'couponDiscount': couponDiscount,
      'couponCode': couponCode,
      'taxAmount': taxAmount,
      'platformFee': platformFee,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'cancellationReason': cancellationReason,
      'createdAt': createdAt.toIso8601String(),
      'isReviewed': isReviewed,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      timeSlot: json['timeSlot'] as String,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      partnerName: json['partnerName'] as String? ?? 'Rahul Sharma',
      partnerPhone: json['partnerPhone'] as String? ?? '+91 98110 54321',
      partnerAvatar: json['partnerAvatar'] as String? ?? '',
      partnerRating: (json['partnerRating'] as num?)?.toDouble() ?? 4.9,
      subtotal: (json['subtotal'] as num).toDouble(),
      serviceDiscount: (json['serviceDiscount'] as num?)?.toDouble() ?? 0.0,
      couponDiscount: (json['couponDiscount'] as num?)?.toDouble() ?? 0.0,
      couponCode: json['couponCode'] as String?,
      taxAmount: (json['taxAmount'] as num).toDouble(),
      platformFee: (json['platformFee'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String? ?? 'UPI',
      paymentStatus: json['paymentStatus'] as String? ?? 'Paid',
      transactionId: json['transactionId'] as String? ?? '',
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isReviewed: json['isReviewed'] as bool? ?? false,
    );
  }
}

