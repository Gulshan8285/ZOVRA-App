import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/widgets/zovra_button.dart';
import '../../../offers/providers/offers_provider.dart';
import '../../providers/cart_provider.dart';

class CouponApplySheet extends ConsumerStatefulWidget {
  const CouponApplySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CouponApplySheet(),
    );
  }

  @override
  ConsumerState<CouponApplySheet> createState() => _CouponApplySheetState();
}

class _CouponApplySheetState extends ConsumerState<CouponApplySheet> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _apply(String code) {
    setState(() => _errorMessage = null);
    final success = ref.read(cartProvider.notifier).applyCoupon(code);
    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon "$code" applied successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final error = ref.read(cartProvider).couponError;
      setState(() => _errorMessage = error ?? 'Could not apply coupon.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final coupons = ref.watch(offersProvider);
    final cartState = ref.watch(cartProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Apply Coupons & Offers',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Code Input Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'Enter coupon code (e.g. ZOVRA20)',
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ZovraButton(
                text: 'Apply',
                width: 90,
                height: 48,
                onPressed: () {
                  if (_codeController.text.trim().isNotEmpty) {
                    _apply(_codeController.text.trim());
                  }
                },
              ),
            ],
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          Text(
            'AVAILABLE COUPONS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: coupons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                final isApplied = cartState.appliedCoupon?.code == coupon.code;
                final isEligible = cartState.subtotal >= coupon.minOrderAmount;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isApplied
                        ? AppColors.primaryLight.withOpacity(0.5)
                        : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isApplied ? AppColors.primary : AppColors.border,
                      width: isApplied ? 1.5 : 0.8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          coupon.code,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              coupon.description,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Min order: ${CurrencyFormatter.format(coupon.minOrderAmount)} · Valid till ${DateTimeUtils.formatMediumDate(coupon.validTill)}',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      isApplied
                          ? TextButton(
                              onPressed: () {
                                ref.read(cartProvider.notifier).removeCoupon();
                                Navigator.of(context).pop();
                              },
                              child: const Text('REMOVE',
                                  style: TextStyle(color: AppColors.error, fontSize: 12)),
                            )
                          : TextButton(
                              onPressed: isEligible
                                  ? () => _apply(coupon.code)
                                  : () {
                                      setState(() {
                                        _errorMessage =
                                            'Add ${CurrencyFormatter.format(coupon.minOrderAmount - cartState.subtotal)} more to use this coupon.';
                                      });
                                    },
                              child: Text(
                                'APPLY',
                                style: TextStyle(
                                  color: isEligible
                                      ? AppColors.primary
                                      : AppColors.textMuted,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

