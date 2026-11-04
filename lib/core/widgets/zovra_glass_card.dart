import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ZovraGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hasGlow;
  final double blurAmount;

  const ZovraGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.hasGlow = false,
    this.blurAmount = 14,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceGlassCard,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.borderGlass.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );

    Widget result = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasGlow ? AppColors.electricGlow : AppColors.cardShadow,
      ),
      child: cardContent,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: result,
        ),
      );
    }

    return result;
  }
}

