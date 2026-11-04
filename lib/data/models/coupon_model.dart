class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String discountType; // 'percentage' or 'flat'
  final double discountValue; // e.g. 20 for 20%, or 300 for ₹300 flat
  final double minOrderAmount;
  final double maxDiscount;
  final DateTime validTill;
  final bool isActive;

  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    required this.maxDiscount,
    required this.validTill,
    this.isActive = true,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderAmount) return 0.0;

    double calculated = 0.0;
    if (discountType == 'percentage') {
      calculated = (subtotal * discountValue) / 100.0;
      if (maxDiscount > 0 && calculated > maxDiscount) {
        calculated = maxDiscount;
      }
    } else {
      // Flat discount
      calculated = discountValue;
      if (calculated > subtotal) {
        calculated = subtotal;
      }
    }
    return calculated;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      'maxDiscount': maxDiscount,
      'validTill': validTill.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      discountType: json['discountType'] as String? ?? 'percentage',
      discountValue: (json['discountValue'] as num).toDouble(),
      minOrderAmount: (json['minOrderAmount'] as num).toDouble(),
      maxDiscount: (json['maxDiscount'] as num).toDouble(),
      validTill: json['validTill'] != null
          ? DateTime.parse(json['validTill'] as String)
          : DateTime.now().add(const Duration(days: 30)),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

