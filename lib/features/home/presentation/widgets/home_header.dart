import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../addresses/presentation/widgets/location_picker_sheet.dart';
import '../../../addresses/providers/address_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../notifications/providers/notifications_provider.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final addressState = ref.watch(addressProvider);
    final selectedAddress = addressState.selectedAddress;
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final cartState = ref.watch(cartProvider);

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              // ZOVRA 2026 Brand Logo
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderGlass.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ZOVRA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.2,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.only(left: 3, top: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.accentCyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Location Selector
              Expanded(
                child: InkWell(
                  onTap: () => LocationPickerSheet.show(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                selectedAddress?.tag ?? 'Home',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        Text(
                          selectedAddress != null
                              ? selectedAddress.shortAddress
                              : 'Golf Course Rd, Gurugram',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Live Cart Icon with Badge
              InkWell(
                onTap: () => context.push('/cart'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlassCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      if (cartState.isNotEmpty)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(3.5),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartState.totalItemCount}',
                              style: const TextStyle(
                                color: AppColors.textOnPrimary,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Notification Bell Icon with Badge
              InkWell(
                onTap: () => context.push('/notifications'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlassCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 19,
                        color: AppColors.textPrimary,
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(3.5),
                            decoration: const BoxDecoration(
                              color: AppColors.accentCyan,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: AppColors.textOnPrimary,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Profile Avatar
              InkWell(
                onTap: () => context.push('/account'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: user?.avatarUrl.isNotEmpty == true
                        ? Image.network(
                            user!.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          )
                        : const Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
