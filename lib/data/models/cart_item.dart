import 'service_item.dart';

class CartItem {
  final String id;
  final ServiceItem service;
  final int quantity;
  final ServicePackage? selectedPackage;
  final List<ServiceAddOn> selectedAddOns;

  CartItem({
    required this.id,
    required this.service,
    this.quantity = 1,
    this.selectedPackage,
    this.selectedAddOns = const [],
  });

  double get basePrice =>
      selectedPackage != null ? selectedPackage!.discountedPrice : service.discountedPrice;

  double get baseOriginalPrice =>
      selectedPackage != null ? selectedPackage!.originalPrice : service.originalPrice;

  double get addOnsPrice =>
      selectedAddOns.fold(0.0, (sum, addon) => sum + addon.price);

  double get unitPrice => basePrice + addOnsPrice;

  double get unitOriginalPrice => baseOriginalPrice + addOnsPrice;

  double get totalPrice => unitPrice * quantity;

  double get totalOriginalPrice => unitOriginalPrice * quantity;

  double get totalSavings => totalOriginalPrice - totalPrice;

  CartItem copyWith({
    String? id,
    ServiceItem? service,
    int? quantity,
    ServicePackage? selectedPackage,
    List<ServiceAddOn>? selectedAddOns,
  }) {
    return CartItem(
      id: id ?? this.id,
      service: service ?? this.service,
      quantity: quantity ?? this.quantity,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service.toJson(),
      'quantity': quantity,
      'selectedPackage': selectedPackage?.toJson(),
      'selectedAddOns': selectedAddOns.map((e) => e.toJson()).toList(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      service: ServiceItem.fromJson(json['service'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      selectedPackage: json['selectedPackage'] != null
          ? ServicePackage.fromJson(json['selectedPackage'] as Map<String, dynamic>)
          : null,
      selectedAddOns: (json['selectedAddOns'] as List<dynamic>?)
              ?.map((e) => ServiceAddOn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

