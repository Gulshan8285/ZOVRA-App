import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/zovra_wordmark.dart';

class StaticPageScreen extends StatelessWidget {
  final String slug; // 'terms', 'privacy', 'about'

  const StaticPageScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    if (slug == 'about') {
      return _buildAboutScreen(context);
    } else if (slug == 'terms') {
      return _buildTermsScreen(context);
    } else {
      return _buildPrivacyScreen(context);
    }
  }

  Widget _buildAboutScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'About ZOVRA',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Hero Banner
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.editorialNavy, Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ZovraWordmark(
                    fontSize: 28,
                    color: Colors.white,
                    dotColor: AppColors.accentIcyBlue,
                    letterSpacing: 2.0,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Five-Star Doorstep Spa & Wellness Platform',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentIcyBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Crafted for discerning individuals seeking hotel-standard therapeutic care in the absolute privacy, hygiene, and comfort of their own home.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mission Statement
            Text(
              'OUR MISSION',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Text(
                'To revolutionize personal wellness by eliminating the inconvenience of spa transit, traffic, and questionable salon hygiene. We bring verified, master therapists equipped with sanitized portable massage tables, fresh single-use sheets, and organic cold-pressed oils directly to your bedside.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4 Pillars of Guarantee
            Text(
              'THE ZOVRA 5-STAR GUARANTEE',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),

            _buildGuaranteeItem(
              icon: Icons.verified_user_rounded,
              title: '100% Background-Verified Therapists',
              description: 'Rigorous 3-tier police background checks, government ID verification, and certified spa academy credentials.',
            ),
            const SizedBox(height: 10),
            _buildGuaranteeItem(
              icon: Icons.sanitizer_rounded,
              title: 'Hospital-Grade Single-Use Hygiene',
              description: 'Portable tables draped with factory-sealed disposable sheets, sanitized headrest covers, and 100% pure organic oils.',
            ),
            const SizedBox(height: 10),
            _buildGuaranteeItem(
              icon: Icons.price_check_rounded,
              title: 'Transparent Fixed Pricing',
              description: 'Zero hidden taxes or traveling surcharges. The price you see at checkout is exactly what you pay.',
            ),
            const SizedBox(height: 10),
            _buildGuaranteeItem(
              icon: Icons.thumb_up_alt_rounded,
              title: '100% Satisfaction or Free Re-work',
              description: 'If you are unsatisfied with your session for any reason, report within 24 hours for a complimentary repeat session.',
            ),

            const SizedBox(height: 24),

            // Official Reference Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ZOVRA TECHNOLOGIES PRIVATE LIMITED',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Website: https://zovra.vercel.app/\nSupport: ${AppConstants.supportEmail}\nCorporate Office: Palm Springs Plaza, Golf Course Road, Gurugram, Haryana 122002\nVersion: 1.0.0 (Production 2026)',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsScreen(BuildContext context) {
    final clauses = [
      {
        'num': '01',
        'title': 'Acceptance of Terms',
        'body':
            'By installing, accessing, or using the ZOVRA customer mobile application or website, you acknowledge having read, understood, and agreed to be legally bound by these Terms & Conditions. If you do not agree with any provision, please immediately cease usage of the application.',
      },
      {
        'num': '02',
        'title': 'Platform Scope & Services',
        'body':
            'ZOVRA operates as an advanced marketplace technology platform connecting verified home service specialists with residential clients. While ZOVRA establishes stringent background checks, onboarding protocols, and hygiene kits, services are rendered by independent certified wellness practitioners.',
      },
      {
        'num': '03',
        'title': 'Pricing, Taxes & Billing',
        'body':
            'All therapy rates quoted within the application are denominated in Indian Rupees (INR) and are inclusive of Goods & Services Tax (GST) unless explicitly noted. Payment can be settled securely via UPI, Credit/Debit cards, Net Banking, or approved digital wallets at the time of scheduling.',
      },
      {
        'num': '04',
        'title': 'Cancellation & Rescheduling Policy',
        'body':
            'Free cancellation and rescheduling are permitted up to 4 hours prior to the booked time slot. Cancellations initiated within 4 hours may incur a nominal cancellation fee of ₹150 to compensate the assigned wellness partner for travel logistics.',
      },
      {
        'num': '05',
        'title': 'Client Conduct & Safety',
        'body':
            'Clients must provide a safe, respectful, and hygienic private environment for service delivery. ZOVRA maintains a strict zero-tolerance policy against any form of harassment, improper conduct, or unlawful requests. Therapists reserve the right to immediately abort the session and notify authorities if safety is compromised.',
      },
      {
        'num': '06',
        'title': 'Quality Guarantee & Re-work',
        'body':
            'Should a customer be unsatisfied with service quality, a complaint must be filed via Help & Support within 24 hours of appointment completion. Eligible reports will receive an immediate investigation and may be awarded a complimentary re-work or credit voucher.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
        children: [
          Text(
            'ZOVRA TERMS OF SERVICE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Effective Date: November 2026 · Official Document',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 18),
          ...clauses.map((c) => _buildClauseCard(c['num']!, c['title']!, c['body']!)),
        ],
      ),
    );
  }

  Widget _buildPrivacyScreen(BuildContext context) {
    final articles = [
      {
        'num': '01',
        'title': 'Data Collection & Purpose',
        'body':
            'ZOVRA collects essential personal identification details including full name, phone number, email address, and service delivery addresses solely to facilitate booking management, customer authentication, and dispatch of nearby service partners.',
      },
      {
        'num': '02',
        'title': 'Device Location Usage',
        'body':
            'Precise location permissions are utilized only with your explicit consent to autocomplete service addresses, calculate accurate partner travel ETAs, and confirm arrival at your doorstep. We do not track background location when the app is inactive.',
      },
      {
        'num': '03',
        'title': 'Payment & PCI-DSS Compliance',
        'body':
            'Card details and banking credentials are never retained on ZOVRA servers. All monetary transactions are processed through RBI-authorized, 256-bit SSL encrypted, PCI-DSS Level 1 certified payment gateways.',
      },
      {
        'num': '04',
        'title': 'Account Deletion & Data Rights',
        'body':
            'In full compliance with Google Play Store and Apple App Store privacy policies, customers retain full rights to request complete deletion of their account and associated data at any time via Profile Settings > Delete Account.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
        children: [
          Text(
            'PRIVACY & DATA PROTECTION',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last updated: November 2026 · GDPR & DPDP Aligned',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 18),
          ...articles.map((a) => _buildClauseCard(a['num']!, a['title']!, a['body']!)),
        ],
      ),
    );
  }

  Widget _buildClauseCard(String number, String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  number,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
