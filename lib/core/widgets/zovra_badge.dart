import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum BadgeType { discount, bestseller, trending, popular, custom }

class ZovraBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final Color? customColor;
  final Color? customTextColor;
  final IconData? icon;

  const ZovraBadge({
    super.key,
    required this.text,
    this.type = BadgeType.custom,
    this.customColor,
    this.customTextColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData? badgeIcon = icon;

    switch (type) {
      case BadgeType.discount:
        bg = AppColors.successLight;
        fg = AppColors.success;
        badgeIcon ??= Icons.local_offer_rounded;
        break;
      case BadgeType.bestseller:
        bg = AppColors.primaryLight;
        fg = AppColors.primary;
        badgeIcon ??= Icons.workspace_premium_rounded;
        break;
      case BadgeType.trending:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF7E22CE);
        badgeIcon ??= Icons.trending_up_rounded;
        break;
      case BadgeType.popular:
        bg = AppColors.infoLight;
        fg = AppColors.info;
        badgeIcon ??= Icons.thumb_up_alt_rounded;
        break;
      case BadgeType.custom:
        bg = customColor ?? AppColors.primaryLight;
        fg = customTextColor ?? AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeIcon != null) ...[
            Icon(badgeIcon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

