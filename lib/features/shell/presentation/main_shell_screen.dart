import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../cart/providers/cart_provider.dart';

class MainShellScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final hasCartItems = cartState.isNotEmpty;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Screen content
          navigationShell,

          // 2026 Floating Cart Dock (if cart has items and not currently viewing cart/checkout)
          if (hasCartItems && currentIndex != 2)
            Positioned(
              left: 16,
              right: 16,
              bottom: 92, // Just above the floating glass nav bar
              child: GestureDetector(
                onTap: () => context.push('/cart'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGlassCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
                        boxShadow: AppColors.electricGlow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${cartState.totalItemCount}',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textOnPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  CurrencyFormatter.format(cartState.finalTotal),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '${cartState.items.length} ${cartState.items.length == 1 ? 'service' : 'services'} added',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'View Cart',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 2026 Floating Glass Bottom Navigation Bar
          Positioned(
            left: 14,
            right: 14,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: AppColors.borderGlass.withOpacity(0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.55),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 18,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          context,
                          index: 0,
                          currentIndex: currentIndex,
                          icon: Icons.home_rounded,
                          label: 'Home',
                        ),
                        _buildNavItem(
                          context,
                          index: 1,
                          currentIndex: currentIndex,
                          icon: Icons.spa_rounded,
                          label: 'Massage',
                        ),
                        _buildNavItem(
                          context,
                          index: 2,
                          currentIndex: currentIndex,
                          icon: Icons.calendar_today_rounded,
                          label: 'Bookings',
                        ),
                        _buildNavItem(
                          context,
                          index: 3,
                          currentIndex: currentIndex,
                          icon: Icons.local_offer_rounded,
                          label: 'Offers',
                        ),
                        _buildNavItem(
                          context,
                          index: 4,
                          currentIndex: currentIndex,
                          icon: Icons.person_rounded,
                          label: 'Account',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
  }) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => _onTap(context, index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: AppColors.primary.withOpacity(0.45), width: 1)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
