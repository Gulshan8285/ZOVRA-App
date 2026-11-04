import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class StaticPageScreen extends StatelessWidget {
  final String slug; // 'terms', 'privacy', 'about'

  const StaticPageScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    String title = 'About ZOVRA';
    String content = '';

    if (slug == 'terms') {
      title = 'Terms & Conditions';
      content = '''
1. Acceptance of Terms
By downloading, registering or using the ZOVRA platform, you agree to be bound by these Terms of Service. If you do not agree, please discontinue using the service immediately.

2. Services & Booking
ZOVRA provides a technology platform connecting customers with verified home service professionals. All bookings made through ZOVRA are subject to provider availability and confirmation.

3. Pricing & Payments
Prices listed in the application include applicable taxes unless specified otherwise. Payment can be made online via UPI, Credit/Debit Cards, Net Banking, or Cash on Delivery where permitted.

4. Cancellation Policy
Free cancellation is available up to 4 hours prior to the scheduled appointment. Cancellations within 4 hours may incur a nominal cancellation fee of ₹150 to compensate our assigned partner.

5. Satisfaction & Re-work Guarantee
If you are not satisfied with the quality of service provided, report the issue within 24 hours through our Help & Support section for an inspection, free re-work, or eligible refund.
''';
    } else if (slug == 'privacy') {
      title = 'Privacy Policy';
      content = '''
1. Information We Collect
We collect personal information such as your name, email address, phone number, and physical service addresses to provide and deliver our home service offerings.

2. Location Data
ZOVRA accesses your device location (with your explicit permission) solely to locate nearby certified service professionals and pinpoint accurate service delivery addresses.

3. Payment Security
We do not store complete credit card or debit card numbers on our servers. All transactions are securely routed through RBI-compliant, PCI-DSS certified payment gateways.

4. Account Deletion
In accordance with Apple and Google Play store compliance guidelines, you have the right to request full deletion of your account and personal data at any time directly through the "Delete Account" option in your Profile settings.
''';
    } else {
      title = 'About ZOVRA';
      content = '''
ZOVRA is an ultra-premium, modern home services booking platform crafted to bring 5-star salon, therapeutic wellness, and home cleaning experiences straight to your doorstep.

Our Mission:
To elevate everyday home care by pairing discerning customers with verified, background-checked, and skilled professionals who deliver immaculate quality without the hassle.

Key Highlights:
• 100% Background-Checked Professionals
• Sealed, Single-Use Sterilized Hygiene Kits
• Upfront, Transparent Pricing with No Hidden Surcharges
• 100% Satisfaction or Free Re-work Guarantee

Version: 1.0.0
Contact: ${AppConstants.supportEmail}
''';
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: November 2026',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              content,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

