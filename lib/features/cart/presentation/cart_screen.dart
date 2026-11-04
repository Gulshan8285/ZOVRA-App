import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../addresses/presentation/widgets/location_picker_sheet.dart';
import '../../addresses/providers/address_provider.dart';
import '../providers/cart_provider.dart';
import 'widgets/bill_summary_card.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/coupon_apply_sheet.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final addressState = ref.watch(addressProvider);
    final selectedAddress = addressState.selectedAddress;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Therapy Cart',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        actions: [
          if (cartState.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
              },
              child: const Text('Clear', style: TextStyle(color: AppColors.error)),
            ),
        ],
      ),
      body: cartState.isEmpty
          ? EmptyView(
              icon: Icons.spa_outlined,
              title: 'Your Cart is Empty',
              subtitle: 'Select from our 10 luxury massage therapies and experience 5-star wellness at home.',
              actionText: 'Explore Massages',
              onAction: () => context.go('/explore'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address Preview
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderGlass.withOpacity(0.35)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Service Delivery Address',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                selectedAddress?.shortAddress ?? 'Select delivery address',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => LocationPickerSheet.show(context),
                          child: const Text('Change', style: TextStyle(color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Cart Items List
                  Text(
                    'Selected Therapies (${cartState.items.length})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...cartState.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CartItemTile(item: item),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Add More Services button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                      backgroundColor: AppColors.surfaceGlassCard,
                    ),
                    icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
                    label: Text(
                      'Add Another Massage',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () => context.go('/explore'),
                  ),

                  const SizedBox(height: 16),

                  // Coupon Section
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: cartState.appliedCoupon != null
                            ? AppColors.success
                            : AppColors.borderGlass.withOpacity(0.35),
                        width: cartState.appliedCoupon != null ? 1.4 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cartState.appliedCoupon != null
                                ? AppColors.successLight
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.local_offer_rounded,
                            color: cartState.appliedCoupon != null ? AppColors.success : AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: cartState.appliedCoupon != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cartState.appliedCoupon!.code} Applied',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.success,
                                      ),
                                    ),
                                    Text(
                                      'Saved ${CurrencyFormatter.format(cartState.couponDiscount)} with this code',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Coupons & Offers',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Save up to 50% on your massage',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        cartState.appliedCoupon != null
                            ? TextButton(
                                onPressed: () {
                                  ref.read(cartProvider.notifier).removeCoupon();
                                },
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(color: AppColors.error),
                                ),
                              )
                            : TextButton(
                                onPressed: () => CouponApplySheet.show(context),
                                child: const Text('Apply', style: TextStyle(color: AppColors.primary)),
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tip Your Service Partner (100% goes to therapist)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderGlass.withOpacity(0.35)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite_rounded, color: AppColors.primary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Tip your wellness partner',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '100% to partner',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildTipChip(context, '₹50'),
                            const SizedBox(width: 8),
                            _buildTipChip(context, '₹100'),
                            const SizedBox(width: 8),
                            _buildTipChip(context, '₹150'),
                            const SizedBox(width: 8),
                            _buildTipChip(context, 'Custom'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bill Summary Card
                  BillSummaryCard(cartState: cartState),

                  const SizedBox(height: 16),

                  // Cancellation policy note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppConstants.cancellationPolicy,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

      // Bottom Checkout Bar
      bottomNavigationBar: cartState.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGlass,
                  border: Border(top: BorderSide(color: AppColors.borderGlass.withOpacity(0.35))),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CurrencyFormatter.format(cartState.finalTotal),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Total Payable',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ZovraButton(
                        text: 'Select Schedule',
                        icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.textOnPrimary, size: 18),
                        onPressed: () {
                          if (selectedAddress == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select or add a delivery address first.'),
                                backgroundColor: AppColors.warning,
                              ),
                            );
                            LocationPickerSheet.show(context);
                            return;
                          }
                          context.push('/checkout');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTipChip(BuildContext context, String label) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tip $label added to your booking!'),
              backgroundColor: AppColors.surface,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderGlass.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
