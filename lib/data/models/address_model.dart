class AddressModel {
  final String id;
  final String tag; // 'Home', 'Office', 'Other'
  final String houseNumber;
  final String buildingName;
  final String streetLocality;
  final String city;
  final String state;
  final String pincode;
  final String contactPhone;
  final String specialInstructions;
  final double latitude;
  final double longitude;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.tag,
    required this.houseNumber,
    required this.buildingName,
    required this.streetLocality,
    required this.city,
    required this.state,
    required this.pincode,
    this.contactPhone = '',
    this.specialInstructions = '',
    this.latitude = 28.4595,
    this.longitude = 77.0266,
    this.isDefault = false,
  });

  String get fullAddress {
    final parts = [
      houseNumber,
      if (buildingName.isNotEmpty) buildingName,
      streetLocality,
      city,
      if (state.isNotEmpty) state,
      pincode,
    ];
    return parts.where((p) => p.trim().isNotEmpty).join(', ');
  }

  String get shortAddress {
    return '$houseNumber, $buildingName, $streetLocality';
  }

  AddressModel copyWith({
    String? id,
    String? tag,
    String? houseNumber,
    String? buildingName,
    String? streetLocality,
    String? city,
    String? state,
    String? pincode,
    String? contactPhone,
    String? specialInstructions,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      houseNumber: houseNumber ?? this.houseNumber,
      buildingName: buildingName ?? this.buildingName,
      streetLocality: streetLocality ?? this.streetLocality,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      contactPhone: contactPhone ?? this.contactPhone,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag': tag,
      'houseNumber': houseNumber,
      'buildingName': buildingName,
      'streetLocality': streetLocality,
      'city': city,
      'state': state,
      'pincode': pincode,
      'contactPhone': contactPhone,
      'specialInstructions': specialInstructions,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      tag: json['tag'] as String? ?? 'Home',
      houseNumber: json['houseNumber'] as String? ?? '',
      buildingName: json['buildingName'] as String? ?? '',
      streetLocality: json['streetLocality'] as String? ?? '',
      city: json['city'] as String? ?? 'Gurugram',
      state: json['state'] as String? ?? 'Haryana',
      pincode: json['pincode'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '',
      specialInstructions: json['specialInstructions'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.4595,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.0266,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}

