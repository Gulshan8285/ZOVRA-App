class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final bool isDemoUser;
  final DateTime createdAt;
  final String? defaultAddressId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    this.isDemoUser = false,
    DateTime? createdAt,
    this.defaultAddressId,
  }) : createdAt = createdAt ?? DateTime.now();

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? isDemoUser,
    DateTime? createdAt,
    String? defaultAddressId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isDemoUser: isDemoUser ?? this.isDemoUser,
      createdAt: createdAt ?? this.createdAt,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'isDemoUser': isDemoUser,
      'createdAt': createdAt.toIso8601String(),
      'defaultAddressId': defaultAddressId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isDemoUser: json['isDemoUser'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      defaultAddressId: json['defaultAddressId'] as String?,
    );
  }

  // Pre-configured Demo User
  factory UserModel.demo() {
    return UserModel(
      id: 'usr_demo_8921',
      name: 'Gulshan Yadav',
      email: 'gulshan.demo@zovra.com',
      phone: '+91 98765 43210',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      isDemoUser: true,
      createdAt: DateTime.now(),
      defaultAddressId: 'addr_demo_1',
    );
  }
}

