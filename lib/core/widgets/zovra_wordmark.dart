import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Official ZOVRA Brand Wordmark
/// Unified across Home header, Welcome screen, About ZOVRA, and Account.
class ZovraWordmark extends StatelessWidget {
  final double fontSize;
  final Color color;
  final Color dotColor;
  final double letterSpacing;
  final bool showDot;

  const ZovraWordmark({
    super.key,
    this.fontSize = 20,
    this.color = AppColors.textPrimary,
    this.dotColor = AppColors.primary,
    this.letterSpacing = 1.5,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final double dotSize = (fontSize * 0.25).clamp(4.0, 8.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        if (showDot)
          Container(
            width: dotSize,
            height: dotSize,
            margin: EdgeInsets.only(left: fontSize * 0.14, top: fontSize * 0.18),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
