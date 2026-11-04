class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badgeText;
  final String actionType; // 'category', 'service', 'coupon'
  final String actionTarget;
  final String? discountTag;
  final String ctaText;
  final String? targetCategoryId;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badgeText = '',
    this.actionType = 'category',
    this.actionTarget = '',
    this.discountTag,
    this.ctaText = 'Book Now',
    this.targetCategoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'badgeText': badgeText,
      'actionType': actionType,
      'actionTarget': actionTarget.isNotEmpty ? actionTarget : (targetCategoryId ?? ''),
      'discountTag': discountTag,
      'ctaText': ctaText,
      'targetCategoryId': targetCategoryId ?? actionTarget,
    };
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    final target = json['targetCategoryId'] as String? ?? json['actionTarget'] as String? ?? '';
    return BannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String,
      badgeText: json['badgeText'] as String? ?? '',
      actionType: json['actionType'] as String? ?? 'category',
      actionTarget: json['actionTarget'] as String? ?? target,
      discountTag: json['discountTag'] as String?,
      ctaText: json['ctaText'] as String? ?? 'Book Now',
      targetCategoryId: target,
    );
  }
}

