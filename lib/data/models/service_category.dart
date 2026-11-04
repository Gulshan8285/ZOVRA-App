class ServiceCategory {
  final String id;
  final String name;
  final String iconName;
  final String imageUrl;
  final String description;
  final int sortOrder;
  final bool isActive;
  final double startingPrice;
  final int serviceCount;
  final double rating;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.imageUrl,
    required this.description,
    this.sortOrder = 0,
    this.isActive = true,
    this.startingPrice = 849.0,
    this.serviceCount = 1,
    this.rating = 4.9,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'imageUrl': imageUrl,
      'description': description,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'startingPrice': startingPrice,
      'serviceCount': serviceCount,
      'rating': rating,
    };
  }

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String? ?? 'spa',
      imageUrl: json['imageUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 849.0,
      serviceCount: json['serviceCount'] as int? ?? 1,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
    );
  }
}
