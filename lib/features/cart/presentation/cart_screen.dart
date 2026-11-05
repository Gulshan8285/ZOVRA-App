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
import '../../offers/providers/offers_provider.dart';
import '../providers/cart_provider.dart';
import 'widgets/bill_summary_card.dart';
import 'widgets/cart_item_tile.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _couponInputController = TextEditingController();

  @override
  void dispose() {
    _couponInputController.dispose();
    super.dispose();
  }

  void _applyManualCoupon() {
    final code = _couponInputController.text.trim();
    if (code.isEmpty) return;

    final success = ref.read(cartProvider.notifier).applyCoupon(code);
    if (success) {
      _couponInputController.clear();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon $code applied successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final error = ref.read(cartProvider).couponError ?? 'Invalid or inactive coupon code';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final addressState = ref.watch(addressProvider);
    final selectedAddress = addressState.selectedAddress;
    final availableOffers = ref.watch(offersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Therapy Cart',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
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
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
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
                                  color: AppColors.textPrimary,
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
                      color: AppColors.textPrimary,
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
                      side: const BorderSide(color: AppColors.primaryBorder),
                      backgroundColor: AppColors.surface,
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
                    onPressed: () => context.push('/massage'),
                  ),

                  const SizedBox(height: 20),

                  // AVAILABLE OFFERS FOR YOU SECTION (Directly inside Checkout)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.local_offer_rounded, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available Offers For You',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Manual Coupon Code Input Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined, size: 18, color: AppColors.textMuted),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _couponInputController,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter coupon code (e.g. WELCOME20)',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _applyManualCoupon(),
                          ),
                        ),
                        TextButton(
                          onPressed: _applyManualCoupon,
                          child: Text(
                            'APPLY',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (cartState.appliedCoupon != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.successBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Coupon ${cartState.appliedCoupon!.code} Applied!',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.success,
                                  ),
                                ),
                                Text(
                                  'Saved ${CurrencyFormatter.format(cartState.couponDiscount)} on this booking',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeCoupon();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Coupon removed.'), backgroundColor: AppColors.dark),
                              );
                            },
                            child: Text(
                              'REMOVE',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // List of Available Coupons
                  ...availableOffers.map((coupon) {
                    final isApplied = cartState.appliedCoupon?.code == coupon.code;
                    final isEligible = cartState.subtotal >= coupon.minOrderAmount;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isApplied
                              ? AppColors.success
                              : (isEligible ? AppColors.primaryBorder : AppColors.border),
                          width: isApplied ? 1.5 : 1,
                        ),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isApplied ? AppColors.successLight : AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isApplied ? AppColors.success : AppColors.primary,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Text(
                                  coupon.code,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: isApplied ? AppColors.success : AppColors.primary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              if (isApplied)
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.successLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_rounded, size: 12, color: AppColors.success),
                                          const SizedBox(width: 3),
                                          Text(
                                            'APPLIED',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.success,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        ref.read(cartProvider.notifier).removeCoupon();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Coupon removed.'), backgroundColor: AppColors.dark),
                                        );
                                      },
                                      child: Text(
                                        'REMOVE',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isEligible ? AppColors.primary : AppColors.surfaceMuted,
                                    foregroundColor: isEligible ? Colors.white : AppColors.textMuted,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    minimumSize: const Size(60, 32),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: isEligible
                                      ? () {
                                          final success = ref.read(cartProvider.notifier).applyCoupon(coupon.code);
                                          if (success) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Coupon ${coupon.code} applied!'),
                                                backgroundColor: AppColors.success,
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    'APPLY',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coupon.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                'Min. booking: ₹${coupon.minOrderAmount.toInt()}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isEligible ? AppColors.textMuted : AppColors.error,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '• Valid till 31 Dec 2026',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Tip Your Service Partner (100% goes to therapist)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: AppColors.cardShadow,
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
                                color: AppColors.textPrimary,
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
                      color: AppColors.surface,
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
                  color: AppColors.surface,
                  border: const Border(top: BorderSide(color: AppColors.border)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
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
                        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
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
              backgroundColor: AppColors.dark,
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
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
