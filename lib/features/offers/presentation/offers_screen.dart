import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/offers_provider.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = ref.watch(offersProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Offers & Coupons',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
        itemCount: coupons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          final isApplied = cartState.appliedCoupon?.code == coupon.code;

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isApplied ? AppColors.success : AppColors.border,
                width: isApplied ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primaryBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_offer_rounded,
                                size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              coupon.code,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: coupon.code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Coupon code "${coupon.code}" copied!'),
                              backgroundColor: AppColors.dark,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Copy',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    coupon.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon.description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Min order: ${CurrencyFormatter.format(coupon.minOrderAmount)} · Expires ${DateTimeUtils.formatMediumDate(coupon.validTill)}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (cartState.isNotEmpty)
                        isApplied
                            ? Text(
                                'APPLIED',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.success,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  final success = ref
                                      .read(cartProvider.notifier)
                                      .applyCoupon(coupon.code);
                                  if (success) {
                                    context.push('/cart');
                                  } else {
                                    final err = ref.read(cartProvider).couponError;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(err ?? 'Could not apply coupon.'),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'APPLY TO CART',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

