import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../core/storage/local_storage_service.dart';
import '../models/address_model.dart';
import '../models/banner_model.dart';
import '../models/booking_model.dart';
import '../models/cart_item.dart';
import '../models/coupon_model.dart';
import '../models/notification_item.dart';
import '../models/review_model.dart';
import '../models/service_category.dart';
import '../models/service_item.dart';
import '../models/support_ticket.dart';

class ZovraRepository {
  final LocalStorageService _storage;
  final _uuid = const Uuid();

  ZovraRepository(this._storage);

  // --- Categories & Banners ---
  List<ServiceCategory> getCategories() => _storage.getCategories();
  List<BannerModel> getBanners() => _storage.getBanners();

  // --- Services ---
  List<ServiceItem> getServices() => _storage.getServices();

  ServiceItem? getServiceById(String id) {
    try {
      return getServices().firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ServiceItem> getServicesByCategory(String categoryId) {
    return getServices().where((s) => s.categoryId == categoryId && s.isActive).toList();
  }

  List<ServiceItem> getPopularServices() {
    return getServices().where((s) => s.isPopular && s.isActive).toList();
  }

  List<ServiceItem> getTrendingServices() {
    return getServices().where((s) => s.isTrending && s.isActive).toList();
  }

  List<ServiceItem> getBestSellers() {
    return getServices().where((s) => s.isBestSeller && s.isActive).toList();
  }

  List<ServiceItem> getRecommendedServices() {
    return getServices().where((s) => s.isRecommended && s.isActive).toList();
  }

  List<ServiceItem> searchServices({
    String query = '',
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? categoryId,
    String sortBy = 'popular', // 'popular', 'price_asc', 'price_desc', 'rating'
  }) {
    var list = getServices().where((s) => s.isActive).toList();

    // Query filter
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      list = list.where((s) {
        final inName = s.name.toLowerCase().contains(q);
        final inDesc = s.shortDescription.toLowerCase().contains(q) ||
            s.fullDescription.toLowerCase().contains(q);
        return inName || inDesc;
      }).toList();
    }

    // Category filter
    if (categoryId != null && categoryId.isNotEmpty) {
      list = list.where((s) => s.categoryId == categoryId).toList();
    }

    // Price filter
    if (minPrice != null) {
      list = list.where((s) => s.discountedPrice >= minPrice).toList();
    }
    if (maxPrice != null) {
      list = list.where((s) => s.discountedPrice <= maxPrice).toList();
    }

    // Rating filter
    if (minRating != null) {
      list = list.where((s) => s.rating >= minRating).toList();
    }

    // Sorting
    switch (sortBy) {
      case 'price_asc':
        list.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case 'price_desc':
        list.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
      default:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    return list;
  }

  // --- Cart Operations ---
  List<CartItem> getCart() => _storage.getCart();

  Future<List<CartItem>> addToCart({
    required ServiceItem service,
    ServicePackage? package,
    List<ServiceAddOn> addOns = const [],
    int quantity = 1,
  }) async {
    final cart = List<CartItem>.from(getCart());
    final index = cart.indexWhere((item) =>
        item.service.id == service.id &&
        item.selectedPackage?.id == package?.id);

    if (index >= 0) {
      final existing = cart[index];
      cart[index] = existing.copyWith(
        quantity: existing.quantity + quantity,
        selectedAddOns: addOns.isNotEmpty ? addOns : existing.selectedAddOns,
      );
    } else {
      cart.add(CartItem(
        id: 'cart_${_uuid.v4().substring(0, 8)}',
        service: service,
        quantity: quantity,
        selectedPackage: package ?? (service.packages.isNotEmpty ? service.packages.first : null),
        selectedAddOns: addOns,
      ));
    }

    await _storage.saveCart(cart);
    return cart;
  }

  Future<List<CartItem>> updateCartItemQuantity(String cartItemId, int newQuantity) async {
    final cart = List<CartItem>.from(getCart());
    if (newQuantity <= 0) {
      cart.removeWhere((item) => item.id == cartItemId);
    } else {
      final index = cart.indexWhere((item) => item.id == cartItemId);
      if (index >= 0) {
        cart[index] = cart[index].copyWith(quantity: newQuantity);
      }
    }
    await _storage.saveCart(cart);
    return cart;
  }

  Future<List<CartItem>> removeFromCart(String cartItemId) async {
    final cart = List<CartItem>.from(getCart());
    cart.removeWhere((item) => item.id == cartItemId);
    await _storage.saveCart(cart);
    return cart;
  }

  Future<void> clearCart() async {
    await _storage.clearCart();
  }

  // --- Coupons ---
  List<CouponModel> getCoupons() => _storage.getCoupons();

  CouponModel? findCoupon(String code) {
    try {
      return getCoupons().firstWhere(
        (c) => c.code.toUpperCase() == code.trim().toUpperCase() && c.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> addCoupon(CouponModel coupon) async {
    final list = List<CouponModel>.from(getCoupons());
    list.add(coupon);
    await _storage.saveCoupons(list);
  }

  // --- Addresses ---
  List<AddressModel> getAddresses() => _storage.getAddresses();

  AddressModel? getSelectedAddress() => _storage.getSelectedAddress();

  Future<List<AddressModel>> addAddress(AddressModel address) async {
    final list = List<AddressModel>.from(getAddresses());
    if (address.isDefault) {
      for (int i = 0; i < list.length; i++) {
        list[i] = list[i].copyWith(isDefault: false);
      }
    }
    list.add(address);
    await _storage.saveAddresses(list);
    return list;
  }

  Future<List<AddressModel>> updateAddress(AddressModel address) async {
    final list = List<AddressModel>.from(getAddresses());
    final index = list.indexWhere((a) => a.id == address.id);
    if (index >= 0) {
      if (address.isDefault) {
        for (int i = 0; i < list.length; i++) {
          list[i] = list[i].copyWith(isDefault: false);
        }
      }
      list[index] = address;
      await _storage.saveAddresses(list);
    }
    return list;
  }

  Future<List<AddressModel>> deleteAddress(String addressId) async {
    final list = List<AddressModel>.from(getAddresses());
    list.removeWhere((a) => a.id == addressId);
    if (list.isNotEmpty && !list.any((a) => a.isDefault)) {
      list[0] = list[0].copyWith(isDefault: true);
    }
    await _storage.saveAddresses(list);
    return list;
  }

  Future<List<AddressModel>> setDefaultAddress(String addressId) async {
    final list = List<AddressModel>.from(getAddresses());
    for (int i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(isDefault: list[i].id == addressId);
    }
    await _storage.saveAddresses(list);
    return list;
  }

  // --- Bookings ---
  List<BookingModel> getBookings() => _storage.getBookings();

  BookingModel? getBookingById(String id) {
    try {
      return getBookings().firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<BookingModel> createBooking({
    required String userId,
    required List<CartItem> items,
    required DateTime scheduledDate,
    required String timeSlot,
    required AddressModel address,
    required double subtotal,
    required double serviceDiscount,
    required double couponDiscount,
    String? couponCode,
    required double taxAmount,
    required double platformFee,
    required double totalAmount,
    required String paymentMethod,
    required String paymentStatus,
    required String transactionId,
  }) async {
    final randomNum = 1000 + Random().nextInt(9000);
    final bookingId = 'ZOV-2026-$randomNum';

    final booking = BookingModel(
      id: bookingId,
      userId: userId,
      items: items,
      scheduledDate: scheduledDate,
      timeSlot: timeSlot,
      address: address,
      status: BookingStatus.confirmed,
      partnerName: 'Vikram Singh',
      partnerPhone: '+91 98112 34567',
      partnerRating: 4.9,
      subtotal: subtotal,
      serviceDiscount: serviceDiscount,
      couponDiscount: couponDiscount,
      couponCode: couponCode,
      taxAmount: taxAmount,
      platformFee: platformFee,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      transactionId: transactionId,
      createdAt: DateTime.now(),
      isReviewed: false,
    );

    final list = List<BookingModel>.from(getBookings());
    list.insert(0, booking);
    await _storage.saveBookings(list);

    // Also push a confirmation notification
    final notif = NotificationItem(
      id: 'notif_${_uuid.v4().substring(0, 8)}',
      title: 'Booking Confirmed ($bookingId)',
      body: 'Your service is scheduled for ${booking.timeSlot}. Our expert partner is assigned.',
      type: 'booking',
      bookingId: bookingId,
      createdAt: DateTime.now(),
    );
    await addNotification(notif);

    // Clear cart after successful booking
    await clearCart();

    return booking;
  }

  Future<BookingModel?> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    final list = List<BookingModel>.from(getBookings());
    final index = list.indexWhere((b) => b.id == bookingId);
    if (index >= 0) {
      final updated = list[index].copyWith(status: newStatus);
      list[index] = updated;
      await _storage.saveBookings(list);

      // Push notification for status change
      final notif = NotificationItem(
        id: 'notif_${_uuid.v4().substring(0, 8)}',
        title: 'Booking Update ($bookingId)',
        body: 'Status changed to: ${newStatus.label}',
        type: 'booking',
        bookingId: bookingId,
        createdAt: DateTime.now(),
      );
      await addNotification(notif);

      return updated;
    }
    return null;
  }

  Future<BookingModel?> cancelBooking(String bookingId, String reason) async {
    final list = List<BookingModel>.from(getBookings());
    final index = list.indexWhere((b) => b.id == bookingId);
    if (index >= 0) {
      final updated = list[index].copyWith(
        status: BookingStatus.cancelled,
        cancellationReason: reason,
      );
      list[index] = updated;
      await _storage.saveBookings(list);

      final notif = NotificationItem(
        id: 'notif_${_uuid.v4().substring(0, 8)}',
        title: 'Booking Cancelled ($bookingId)',
        body: 'Your booking has been cancelled. Any eligible refund will be credited in 24 hours.',
        type: 'booking',
        bookingId: bookingId,
        createdAt: DateTime.now(),
      );
      await addNotification(notif);

      return updated;
    }
    return null;
  }

  // --- Reviews ---
  List<ReviewModel> getReviews({String? serviceId}) {
    final list = _storage.getReviews();
    if (serviceId != null) {
      return list.where((r) => r.serviceId == serviceId).toList();
    }
    return list;
  }

  Future<void> addReview({
    required String bookingId,
    required String serviceId,
    required String serviceName,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
    List<String> tags = const [],
  }) async {
    final review = ReviewModel(
      id: 'rev_${_uuid.v4().substring(0, 8)}',
      serviceId: serviceId,
      serviceName: serviceName,
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      tags: tags,
      createdAt: DateTime.now(),
      isVerifiedBooking: true,
    );

    final list = List<ReviewModel>.from(_storage.getReviews());
    list.insert(0, review);
    await _storage.saveReviews(list);

    // Mark booking as reviewed
    final bookings = List<BookingModel>.from(getBookings());
    final bIndex = bookings.indexWhere((b) => b.id == bookingId);
    if (bIndex >= 0) {
      bookings[bIndex] = bookings[bIndex].copyWith(isReviewed: true);
      await _storage.saveBookings(bookings);
    }
  }

  // --- Notifications ---
  List<NotificationItem> getNotifications() => _storage.getNotifications();

  Future<void> addNotification(NotificationItem notif) async {
    final list = List<NotificationItem>.from(_storage.getNotifications());
    list.insert(0, notif);
    await _storage.saveNotifications(list);
  }

  Future<void> markNotificationAsRead(String id) async {
    final list = List<NotificationItem>.from(_storage.getNotifications());
    final index = list.indexWhere((n) => n.id == id);
    if (index >= 0) {
      list[index] = list[index].copyWith(isRead: true);
      await _storage.saveNotifications(list);
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final list = _storage.getNotifications().map((n) => n.copyWith(isRead: true)).toList();
    await _storage.saveNotifications(list);
  }

  // --- Support Tickets ---
  List<SupportTicket> getSupportTickets() => _storage.getSupportTickets();

  Future<SupportTicket> createSupportTicket({
    required String userId,
    required String category,
    required String subject,
    required String message,
    String? bookingId,
  }) async {
    final randomNum = 1000 + Random().nextInt(9000);
    final ticket = SupportTicket(
      id: 'tkt_${_uuid.v4().substring(0, 8)}',
      ticketNumber: 'TKT-$randomNum',
      userId: userId,
      category: category,
      subject: subject,
      message: message,
      status: 'Open',
      bookingId: bookingId,
      createdAt: DateTime.now(),
    );

    final list = List<SupportTicket>.from(getSupportTickets());
    list.insert(0, ticket);
    await _storage.saveSupportTickets(list);
    return ticket;
  }

  // --- Admin Operations ---
  Future<void> toggleServiceStatus(String serviceId) async {
    final list = List<ServiceItem>.from(getServices());
    final index = list.indexWhere((s) => s.id == serviceId);
    if (index >= 0) {
      final current = list[index];
      // Note: we can recreate or adjust isActive
      list[index] = ServiceItem(
        id: current.id,
        categoryId: current.categoryId,
        name: current.name,
        shortDescription: current.shortDescription,
        fullDescription: current.fullDescription,
        imageUrl: current.imageUrl,
        gallery: current.gallery,
        originalPrice: current.originalPrice,
        discountedPrice: current.discountedPrice,
        durationMinutes: current.durationMinutes,
        rating: current.rating,
        reviewCount: current.reviewCount,
        isPopular: current.isPopular,
        isTrending: current.isTrending,
        isBestSeller: current.isBestSeller,
        isRecommended: current.isRecommended,
        whatsIncluded: current.whatsIncluded,
        benefits: current.benefits,
        faqs: current.faqs,
        packages: current.packages,
        addOns: current.addOns,
        isActive: !current.isActive,
      );
      await _storage.saveServices(list);
    }
  }

  Future<void> addService(ServiceItem service) async {
    final list = List<ServiceItem>.from(getServices());
    list.add(service);
    await _storage.saveServices(list);
  }
}

