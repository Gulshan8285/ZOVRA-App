import 'package:flutter/material.dart';

/// ZOVRA 2026 Premium Dark Glass Design Tokens
/// Strict Brand Identity: Deep Midnight Black, Dark Navy, Electric / Icy Blue Glow
/// Absolutely NO ORANGE.
class AppColors {
  // Brand Backgrounds (Deep Midnight Black / Void)
  static const Color background = Color(0xFF080A0F);
  static const Color backgroundSecondary = Color(0xFF0D121D);
  static const Color backgroundElevated = Color(0xFF111827);

  // Glass & Dark Surfaces
  static const Color surface = Color(0xFF111827);
  static const Color surfaceMuted = Color(0xFF161F33);
  static const Color surfaceCard = Color(0xFF141C2E);
  static const Color surfaceGlass = Color(0xCC0F172A);
  static const Color surfaceGlassCard = Color(0x99162035);
  static const Color surfaceGlassHover = Color(0xCC1A2640);
  static const Color dark = Color(0xFF141C2E);

  // Brand Primary & Accents (Electric Blue & Icy Blue)
  static const Color primary = Color(0xFF00D2FF);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryLight = Color(0xFF0C243B);
  static const Color primaryBorder = Color(0xFF1E3A5F);
  static const Color primaryGlowColor = Color(0xFF00D2FF);

  // Icy Blue / Cyan Secondary Accents
  static const Color accentIcyBlue = Color(0xFF38BDF8);
  static const Color accentCyan = Color(0xFF00F0FF);
  static const Color accentNavy = Color(0xFF1E293B);

  // WhatsApp Brand Color (for direct WhatsApp sharing)
  static const Color whatsapp = Color(0xFF25D366);

  // Borders & Glass Dividers
  static const Color border = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFF26354D);
  static const Color borderGlass = Color(0x3338BDF8);
  static const Color borderSubtle = Color(0x1AFFFFFF);
  static const Color divider = Color(0xFF1E293B);

  // Text Colors (Crisp White & Soft Slate Grey)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);
  static const Color textOnPrimary = Color(0xFF080A0F);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF064E3B);
  static const Color successBorder = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFF451A03);

  static const Color error = Color(0xFFF43F5E);
  static const Color errorLight = Color(0xFF4C0519);

  static const Color info = Color(0xFF38BDF8);
  static const Color infoLight = Color(0xFF082F49);

  // Rating
  static const Color ratingGold = Color(0xFFFBBF24);

  // Shimmer
  static const Color shimmerBase = Color(0xFF161F33);
  static const Color shimmerHighlight = Color(0xFF22314E);

  // Shadows & Electric Glows
  static List<BoxShadow> electricGlow = [
    BoxShadow(
      color: primary.withOpacity(0.35),
      blurRadius: 18,
      spreadRadius: -2,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cyanGlow = [
    BoxShadow(
      color: accentCyan.withOpacity(0.30),
      blurRadius: 16,
      spreadRadius: -2,
    ),
  ];

  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.45),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: primary.withOpacity(0.30),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
