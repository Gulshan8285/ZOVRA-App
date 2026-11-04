import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class TrustMetricsBanner extends StatelessWidget {
  const TrustMetricsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlassCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderGlass.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'THE ZOVRA CARE PLEDGE',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '5-Star Luxury Standards at Home',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(Icons.verified_rounded, 'Certified Pros', 'Background checked'),
              _buildMetricItem(Icons.single_bed_rounded, 'Spa Table', 'Therapist brings bed'),
              _buildMetricItem(Icons.sanitizer_rounded, 'Sealed Linens', '100% single-use'),
              _buildMetricItem(Icons.lock_outline_rounded, '100% Privacy', 'Strict ethical code'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
