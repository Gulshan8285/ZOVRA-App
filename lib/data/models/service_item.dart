class ServicePackage {
  final String id;
  final String title;
  final String durationText;
  final double originalPrice;
  final double discountedPrice;
  final String description;

  const ServicePackage({
    required this.id,
    required this.title,
    required this.durationText,
    required this.originalPrice,
    required this.discountedPrice,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationText': durationText,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'description': description,
    };
  }

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      id: json['id'] as String,
      title: json['title'] as String,
      durationText: json['durationText'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      description: json['description'] as String? ?? '',
    );
  }
}

class ServiceAddOn {
  final String id;
  final String name;
  final double price;
  final String description;

  const ServiceAddOn({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  factory ServiceAddOn.fromJson(Map<String, dynamic> json) {
    return ServiceAddOn(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
    );
  }
}

class ServiceItem {
  final String id;
  final String categoryId;
  final String name;
  final String shortDescription;
  final String fullDescription;
  final String imageUrl;
  final List<String> gallery;
  final double originalPrice;
  final double discountedPrice;
  final int durationMinutes;
  final double rating;
  final int reviewCount;
  final bool isPopular;
  final bool isTrending;
  final bool isBestSeller;
  final bool isRecommended;
  final List<String> whatsIncluded;
  final List<String> benefits;
  final List<String> preparationInstructions;
  final List<Map<String, String>> faqs;
  final List<ServicePackage> packages;
  final List<ServiceAddOn> addOns;
  final bool isActive;

  const ServiceItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.imageUrl,
    this.gallery = const [],
    required this.originalPrice,
    required this.discountedPrice,
    required this.durationMinutes,
    required this.rating,
    required this.reviewCount,
    this.isPopular = false,
    this.isTrending = false,
    this.isBestSeller = false,
    this.isRecommended = false,
    this.whatsIncluded = const [],
    this.benefits = const [],
    this.preparationInstructions = const [],
    this.faqs = const [],
    this.packages = const [],
    this.addOns = const [],
    this.isActive = true,
  });

  int get discountPercentage {
    if (originalPrice <= 0 || discountedPrice >= originalPrice) return 0;
    return (((originalPrice - discountedPrice) / originalPrice) * 100).round();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'imageUrl': imageUrl,
      'gallery': gallery,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'durationMinutes': durationMinutes,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPopular': isPopular,
      'isTrending': isTrending,
      'isBestSeller': isBestSeller,
      'isRecommended': isRecommended,
      'whatsIncluded': whatsIncluded,
      'benefits': benefits,
      'preparationInstructions': preparationInstructions,
      'faqs': faqs,
      'packages': packages.map((p) => p.toJson()).toList(),
      'addOns': addOns.map((a) => a.toJson()).toList(),
      'isActive': isActive,
    };
  }

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      fullDescription: json['fullDescription'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      gallery: (json['gallery'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int? ?? 60,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['reviewCount'] as int? ?? 120,
      isPopular: json['isPopular'] as bool? ?? false,
      isTrending: json['isTrending'] as bool? ?? false,
      isBestSeller: json['isBestSeller'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      whatsIncluded: (json['whatsIncluded'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      benefits: (json['benefits'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      preparationInstructions: (json['preparationInstructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      faqs: (json['faqs'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
      packages: (json['packages'] as List<dynamic>?)
              ?.map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      addOns: (json['addOns'] as List<dynamic>?)
              ?.map((e) => ServiceAddOn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
