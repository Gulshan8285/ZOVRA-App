import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppShareService {
  static const String websiteUrl = 'https://zovra.vercel.app';
  static const String brandDomain = 'https://zovra.com';

  /// Share any text directly to WhatsApp, with fallback to native OS share sheet
  static Future<void> shareText({required String message, String? subject}) async {
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUri = Uri.parse('whatsapp://send?text=$encodedMessage');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {
      // Fallback to native share sheet
    }

    // Native OS share sheet (works on Android & iOS unconditionally)
    await Share.share(message, subject: subject ?? 'ZOVRA Wellness');
  }

  /// Share a specific Massage Service
  static Future<void> shareService({
    required String serviceName,
    required double price,
    required int durationMinutes,
    String? categoryName,
  }) async {
    final text = '🌿 Discover 5-Star Wellness at Home with *ZOVRA*!\n\n'
        '💆‍♂️ *$serviceName*\n'
        '⏱ Duration: $durationMinutes Minutes\n'
        '💰 Special Rate: ₹${price.toInt()} (Includes mobile spa bed & certified therapist)\n\n'
        'Book your personal wellness session now:\n'
        '$websiteUrl/services';

    await shareText(message: text, subject: 'ZOVRA – $serviceName');
  }

  /// Share an Offer / Coupon
  static Future<void> shareOffer({
    required String couponCode,
    required String discountDescription,
  }) async {
    final text = '✨ Exclusive ZOVRA Wellness Offer!\n\n'
        'Use code *$couponCode* to get $discountDescription on your next doorstep massage therapy.\n\n'
        'Claim your offer now on ZOVRA:\n'
        '$websiteUrl';

    await shareText(message: text, subject: 'ZOVRA Discount Code: $couponCode');
  }

  /// Share Booking Confirmation (without revealing private credentials)
  static Future<void> shareBookingConfirmation({
    required String bookingId,
    required String serviceName,
    required String dateTimeText,
  }) async {
    final text = '✅ Booked my in-home wellness session with *ZOVRA*!\n\n'
        '💆 Service: $serviceName\n'
        '🗓 Scheduled: $dateTimeText\n'
        '🔖 Ref: $bookingId\n\n'
        'Experience luxury therapeutic massages in your room:\n'
        '$websiteUrl';

    await shareText(message: text, subject: 'ZOVRA Appointment Confirmed');
  }

  /// Share ZOVRA Website & Referral
  static Future<void> shareApp() async {
    const text = 'Discover premium wellness & therapeutic massage experiences at your doorstep with *ZOVRA*.\n\n'
        'Certified male wellness therapists, portable spa beds, sealed single-use linens & cold-pressed oils.\n\n'
        'Explore therapies at:\n'
        '$websiteUrl';

    await shareText(message: text, subject: 'ZOVRA – Premium Home Wellness');
  }
}

