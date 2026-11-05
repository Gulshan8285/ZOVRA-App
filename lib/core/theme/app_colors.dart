import 'package:flutter/material.dart';

/// ZOVRA 2026 Urban Company-Inspired Clean Minimal Design Tokens
/// Strict Brand Identity: Soft Off-White, Pure White Cards, Deep Charcoal Typography,
/// Sophisticated Indigo/Blue Accents, Subtle Icy Blue Tints, Light Grey Dividers.
/// Absolutely NO ORANGE. NO EXCESSIVE NEON GLOWS.
class AppColors {
  // Brand Backgrounds (Clean, Minimal, Soft Off-White)
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundSecondary = Color(0xFFF1F5F9);
  static const Color backgroundElevated = Color(0xFFFFFFFF);

  // Surfaces & Cards (Pure Crisp White)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3F4F6);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceGlass = Color(0xF5FFFFFF);
  static const Color surfaceGlassCard = Color(0xFFFFFFFF);
  static const Color surfaceGlassHover = Color(0xFFF8FAFC);
  static const Color dark = Color(0xFF111827); // Deep Charcoal for select dark editorial banners
  static const Color editorialNavy = Color(0xFF0F172A); // High-end Navy for Hero Banners

  // Brand Primary & Accents (Sophisticated Indigo / Royal Blue - Trustworthy & High-End)
  static const Color primary = Color(0xFF2563EB); // Modern Royal Indigo Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFEFF6FF); // Soft Icy Blue pill tint
  static const Color primaryBorder = Color(0xFFBFDBFE); // Subtle blue border for active states
  static const Color primaryGlowColor = Color(0x252563EB);

  // Secondary Accents
  static const Color accentIcyBlue = Color(0xFF0284C7);
  static const Color accentCyan = Color(0xFF0EA5E9);
  static const Color accentNavy = Color(0xFF0F172A);

  // WhatsApp Brand Color (for direct WhatsApp sharing & support)
  static const Color whatsapp = Color(0xFF25D366);

  // Borders & Dividers (Very subtle, clean light grey)
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderGlass = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFF1F5F9);

  // Text Colors (Deep Charcoal & Muted Slate - Superb Readability)
  static const Color textPrimary = Color(0xFF111827); // Deep Charcoal
  static const Color textSecondary = Color(0xFF4B5563); // Muted Slate Grey
  static const Color textMuted = Color(0xFF6B7280); // Secondary Slate
  static const Color textDisabled = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Pure White on Indigo CTA
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Status & Feedback Colors
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);

  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFFFBEB);

  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEF2F2);

  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Rating Gold
  static const Color ratingGold = Color(0xFFEAB308);

  // Shimmer
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);

  // Shadows (Soft, Natural, Professional Mobile Shadows - No Harsh Neon Outlines)
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> electricGlow = [
    BoxShadow(
      color: primary.withOpacity(0.18),
      blurRadius: 14,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cyanGlow = [
    BoxShadow(
      color: accentCyan.withOpacity(0.15),
      blurRadius: 12,
    ),
  ];

  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: primary.withOpacity(0.18),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ];
}
