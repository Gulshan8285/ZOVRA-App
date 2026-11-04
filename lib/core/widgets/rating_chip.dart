import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class RatingChip extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final bool compact;
  final bool useGreen;

  const RatingChip({
    super.key,
    required this.rating,
    this.reviewCount,
    this.compact = false,
    this.useGreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = useGreen ? const Color(0xFF0F8454) : AppColors.ratingGold;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: bgColor.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: compact ? 13 : 15,
            color: bgColor,
          ),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.plusJakartaSans(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: bgColor,
            ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 3),
            Text(
              '($reviewCount)',
              style: GoogleFonts.inter(
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

