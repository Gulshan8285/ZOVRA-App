class AppConstants {
  static const String appName = 'ZOVRA';
  static const String appTagline = 'Premium Home Services at Your Doorstep';
  static const String currencySymbol = '₹';
  static const String defaultCity = 'Gurugram, Haryana';
  static const String defaultAddressSnippet = 'Sector 43, Golf Course Road';

  // Configurable booking fee & taxes
  static const double taxPercentage = 18.0; // 18% GST for services
  static const double platformFee = 49.0;
  static const double freeDeliveryThreshold = 999.0;
  static const double standardVisitingCharge = 49.0;

  // Contact & Support
  static const String supportEmail = 'care@zovra.com';
  static const String supportPhone = '+91 8000 900 800';
  static const String supportWhatsApp = '+918000900800';

  // Policies
  static const String cancellationPolicy =
      'Free cancellation up to 4 hours before your scheduled appointment slot. Late cancellations (within 4 hours) may incur a nominal cancellation fee of ₹150 to compensate our assigned service partner.';

  // Local storage keys
  static const String keyUser = 'zovra_user_session';
  static const String keyCart = 'zovra_cart_items';
  static const String keyAddresses = 'zovra_saved_addresses';
  static const String keyBookings = 'zovra_bookings_list';
  static const String keySelectedAddress = 'zovra_selected_address';
  static const String keyNotifications = 'zovra_notifications_list';
  static const String keyReviews = 'zovra_reviews_list';
  static const String keySupportTickets = 'zovra_support_tickets';
  static const String keyServicesCatalog = 'zovra_services_catalog';
  static const String keyCoupons = 'zovra_coupons_list';
  static const String keyHasOnboarded = 'zovra_has_onboarded';
}

