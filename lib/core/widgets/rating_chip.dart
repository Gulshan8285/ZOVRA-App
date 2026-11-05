import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ZOVRA 2026 Unified High-Contrast Rating Badge
/// Strictly adheres to Urban Company / Airbnb aesthetic:
/// - Highly visible amber-gold star icon
/// - Bold, prominent charcoal rating number (e.g. 4.9)
/// - Clean review count with clear contrast (e.g. 420 or 1.2k)
/// - Solid, crisp background preventing dark-on-dark or invisible text over photos
class RatingChip extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final bool compact;
  final bool onImage;

  const RatingChip({
    super.key,
    required this.rating,
    this.reviewCount,
    this.compact = false,
    this.onImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedRating = rating.toStringAsFixed(1);

    if (onImage) {
      // Over photo / image overlay badge: Pure crisp white pill with shadow
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 7 : 9,
          vertical: compact ? 3 : 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.star_rounded,
              size: 14,
              color: Color(0xFFF59E0B), // Vibrant Amber Gold
            ),
            const SizedBox(width: 3.5),
            Text(
              formattedRating,
              style: GoogleFonts.plusJakartaSans(
                fontSize: compact ? 11 : 12.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827), // Deep Charcoal - 100% readable
              ),
            ),
            if (reviewCount != null && reviewCount! > 0) ...[
              const SizedBox(width: 4),
              Text(
                '($reviewCount)',
                style: GoogleFonts.inter(
                  fontSize: compact ? 10 : 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4B5563), // Slate Grey - distinct & sharp
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Standard in-card / page badge: Clean warm amber-tinted badge with charcoal typography
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withOpacity(0.65), // Soft warm amber
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFDE68A),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 14,
            color: Color(0xFFD97706), // Rich Gold Star
          ),
          const SizedBox(width: 4),
          Text(
            formattedRating,
            style: GoogleFonts.plusJakartaSans(
              fontSize: compact ? 11 : 12.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF92400E), // Deep Amber-Brown
            ),
          ),
          if (reviewCount != null && reviewCount! > 0) ...[
            const SizedBox(width: 4),
            Text(
              '($reviewCount)',
              style: GoogleFonts.inter(
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF78350F).withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
