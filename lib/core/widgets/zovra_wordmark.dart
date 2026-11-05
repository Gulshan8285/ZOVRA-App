import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Official ZOVRA Brand Wordmark
/// Unified across Home header, Welcome screen, About ZOVRA, and Account.
/// Supports clean "ZOVRA.com" typography with royal indigo accent dot.
class ZovraWordmark extends StatelessWidget {
  final double fontSize;
  final Color color;
  final Color dotColor;
  final double letterSpacing;
  final bool showDot;
  final bool showCom;

  const ZovraWordmark({
    super.key,
    this.fontSize = 20,
    this.color = AppColors.textPrimary,
    this.dotColor = AppColors.primary,
    this.letterSpacing = 1.5,
    this.showDot = true,
    this.showCom = true,
  });

  @override
  Widget build(BuildContext context) {
    final double dotSize = (fontSize * 0.22).clamp(3.5, 6.5);
    final double comFontSize = (fontSize * 0.58).clamp(9.0, 24.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'ZOVRA',
          style: GoogleFonts.plusJakartaSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: letterSpacing,
            color: color,
          ),
        ),
        if (showCom) ...[
          Container(
            width: dotSize,
            height: dotSize,
            margin: EdgeInsets.symmetric(horizontal: fontSize * 0.08),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            'com',
            style: GoogleFonts.plusJakartaSans(
              fontSize: comFontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: dotColor,
            ),
          ),
        ] else if (showDot) ...[
          Container(
            width: dotSize,
            height: dotSize,
            margin: EdgeInsets.only(left: fontSize * 0.12),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}
