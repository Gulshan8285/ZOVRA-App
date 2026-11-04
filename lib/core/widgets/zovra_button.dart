import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum ZovraButtonVariant { primary, secondary, outline, glass, danger }

class ZovraButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final ZovraButtonVariant variant;
  final double? width;
  final double height;
  final double borderRadius;

  const ZovraButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = ZovraButtonVariant.primary,
    this.width,
    this.height = 50,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case ZovraButtonVariant.primary:
        bgColor = AppColors.primary;
        fgColor = AppColors.textOnPrimary;
        break;
      case ZovraButtonVariant.secondary:
        bgColor = AppColors.surfaceMuted;
        fgColor = AppColors.textPrimary;
        borderSide = const BorderSide(color: AppColors.border, width: 1);
        break;
      case ZovraButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.textPrimary;
        borderSide = const BorderSide(color: AppColors.primaryBorder, width: 1.2);
        break;
      case ZovraButtonVariant.glass:
        bgColor = AppColors.surfaceGlassCard;
        fgColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.borderGlass, width: 1);
        break;
      case ZovraButtonVariant.danger:
        bgColor = AppColors.errorLight;
        fgColor = AppColors.error;
        borderSide = const BorderSide(color: AppColors.error, width: 1);
        break;
    }

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: (variant == ZovraButtonVariant.primary && onPressed != null)
            ? AppColors.electricGlow
            : null,
      ),
      child: Material(
        color: onPressed == null ? AppColors.surfaceMuted.withOpacity(0.5) : bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide,
        ),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        variant == ZovraButtonVariant.primary
                            ? AppColors.textOnPrimary
                            : AppColors.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: onPressed == null ? AppColors.textMuted : fgColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
