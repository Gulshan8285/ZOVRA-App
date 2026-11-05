import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../data/models/address_model.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/coupon_model.dart';
import '../../data/models/notification_item.dart';
import '../../data/models/review_model.dart';
import '../../data/models/service_category.dart';
import '../../data/models/service_item.dart';
import '../../data/models/support_ticket.dart';
import '../../data/models/user_model.dart';
import '../../data/seeds/initial_data.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = LocalStorageService(prefs);
    await service._ensureInitialDataSeeded();
    return service;
  }

  Future<void> _ensureInitialDataSeeded() async {
    const String currentCatalogVersion = 'v9_zovra_premium_verified_images';
    if (_prefs.getString('zovra_catalog_version') != currentCatalogVersion) {
      final services = InitialData.getServices();
      await saveServices(services);
      final categories = InitialData.getCategories();
      await saveCategories(categories);
      final banners = InitialData.getBanners();
      await saveBanners(banners);
      final coupons = InitialData.getCoupons();
      await saveCoupons(coupons);
      await _prefs.setString('zovra_catalog_version', currentCatalogVersion);
    }

    // Seed Coupons if not present
    if (!_prefs.containsKey(AppConstants.keyCoupons)) {
      final coupons = InitialData.getCoupons();
      await saveCoupons(coupons);
    }

    // Seed Addresses if not present
    if (!_prefs.containsKey(AppConstants.keyAddresses)) {
      final addresses = InitialData.getAddresses();
      await saveAddresses(addresses);
    }

    // Seed Bookings if not present
    if (!_prefs.containsKey(AppConstants.keyBookings)) {
      final bookings = InitialData.getInitialBookings();
      await saveBookings(bookings);
    }

    // Seed Reviews if not present or upgrade if seed has expanded
    final existingReviews = getReviews();
    if (!_prefs.containsKey(AppConstants.keyReviews) || existingReviews.length < InitialData.getReviews().length) {
      final reviews = InitialData.getReviews();
      await saveReviews(reviews);
    }

    // Seed Notifications if not present
    if (!_prefs.containsKey(AppConstants.keyNotifications)) {
      final notifications = InitialData.getNotifications();
      await saveNotifications(notifications);
    }

    // Seed Support Tickets if not present
    if (!_prefs.containsKey(AppConstants.keySupportTickets)) {
      final tickets = InitialData.getInitialSupportTickets();
      await saveSupportTickets(tickets);
    }
  }

  // --- User Session ---
  UserModel? getUser() {
    final jsonStr = _prefs.getString(AppConstants.keyUser);
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(AppConstants.keyUser, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    await _prefs.remove(AppConstants.keyUser);
  }

  // --- Onboarding Status ---
  bool get hasOnboarded => _prefs.getBool(AppConstants.keyHasOnboarded) ?? false;

  Future<void> setHasOnboarded(bool value) async {
    await _prefs.setBool(AppConstants.keyHasOnboarded, value);
  }

  // --- Services ---
  List<ServiceItem> getServices() {
    final jsonStr = _prefs.getString(AppConstants.keyServicesCatalog);
    if (jsonStr == null) return InitialData.getServices();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getServices();
    }
  }

  Future<void> saveServices(List<ServiceItem> services) async {
    final list = services.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyServicesCatalog, jsonEncode(list));
  }

  // --- Categories ---
  List<ServiceCategory> getCategories() {
    final jsonStr = _prefs.getString('zovra_categories_catalog');
    if (jsonStr == null) return InitialData.getCategories();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => ServiceCategory.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getCategories();
    }
  }

  Future<void> saveCategories(List<ServiceCategory> categories) async {
    final list = categories.map((e) => e.toJson()).toList();
    await _prefs.setString('zovra_categories_catalog', jsonEncode(list));
  }

  // --- Banners ---
  List<BannerModel> getBanners() {
    final jsonStr = _prefs.getString('zovra_banners_catalog');
    if (jsonStr == null) return InitialData.getBanners();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getBanners();
    }
  }

  Future<void> saveBanners(List<BannerModel> banners) async {
    final list = banners.map((e) => e.toJson()).toList();
    await _prefs.setString('zovra_banners_catalog', jsonEncode(list));
  }

  // --- Cart ---
  List<CartItem> getCart() {
    final jsonStr = _prefs.getString(AppConstants.keyCart);
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCart(List<CartItem> items) async {
    final list = items.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyCart, jsonEncode(list));
  }

  Future<void> clearCart() async {
    await _prefs.remove(AppConstants.keyCart);
  }

  // --- Coupons ---
  List<CouponModel> getCoupons() {
    final jsonStr = _prefs.getString(AppConstants.keyCoupons);
    if (jsonStr == null) return InitialData.getCoupons();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => CouponModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getCoupons();
    }
  }

  Future<void> saveCoupons(List<CouponModel> coupons) async {
    final list = coupons.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyCoupons, jsonEncode(list));
  }

  // --- Addresses ---
  List<AddressModel> getAddresses() {
    final jsonStr = _prefs.getString(AppConstants.keyAddresses);
    if (jsonStr == null) return InitialData.getAddresses();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => AddressModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getAddresses();
    }
  }

  Future<void> saveAddresses(List<AddressModel> addresses) async {
    final list = addresses.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyAddresses, jsonEncode(list));
  }

  AddressModel? getSelectedAddress() {
    final addresses = getAddresses();
    if (addresses.isEmpty) return null;
    final defaultAddr = addresses.where((a) => a.isDefault).toList();
    if (defaultAddr.isNotEmpty) return defaultAddr.first;
    return addresses.first;
  }

  // --- Bookings ---
  List<BookingModel> getBookings() {
    final jsonStr = _prefs.getString(AppConstants.keyBookings);
    if (jsonStr == null) return InitialData.getInitialBookings();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getInitialBookings();
    }
  }

  Future<void> saveBookings(List<BookingModel> bookings) async {
    final list = bookings.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyBookings, jsonEncode(list));
  }

  // --- Reviews ---
  List<ReviewModel> getReviews() {
    final jsonStr = _prefs.getString(AppConstants.keyReviews);
    if (jsonStr == null) return InitialData.getReviews();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getReviews();
    }
  }

  Future<void> saveReviews(List<ReviewModel> reviews) async {
    final list = reviews.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyReviews, jsonEncode(list));
  }

  // --- Notifications ---
  List<NotificationItem> getNotifications() {
    final jsonStr = _prefs.getString(AppConstants.keyNotifications);
    if (jsonStr == null) return InitialData.getNotifications();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getNotifications();
    }
  }

  Future<void> saveNotifications(List<NotificationItem> notifs) async {
    final list = notifs.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyNotifications, jsonEncode(list));
  }

  // --- Support Tickets ---
  List<SupportTicket> getSupportTickets() {
    final jsonStr = _prefs.getString(AppConstants.keySupportTickets);
    if (jsonStr == null) return InitialData.getInitialSupportTickets();
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => SupportTicket.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return InitialData.getInitialSupportTickets();
    }
  }

  Future<void> saveSupportTickets(List<SupportTicket> tickets) async {
    final list = tickets.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keySupportTickets, jsonEncode(list));
  }
}

