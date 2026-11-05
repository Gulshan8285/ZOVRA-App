import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../providers/cart_provider.dart';

class BillSummaryCard extends StatelessWidget {
  final CartState cartState;

  const BillSummaryCard({super.key, required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // Item Total
          _buildBillRow('Item Subtotal', CurrencyFormatter.format(cartState.subtotal)),

          // Direct Service Savings
          if (cartState.serviceDiscount > 0)
            _buildBillRow(
              'Service Discount',
              '- ${CurrencyFormatter.format(cartState.serviceDiscount)}',
              isGreen: true,
            ),

          // Coupon Savings
          if (cartState.appliedCoupon != null)
            _buildBillRow(
              'Coupon (${cartState.appliedCoupon!.code})',
              '- ${CurrencyFormatter.format(cartState.couponDiscount)}',
              isGreen: true,
            ),

          // Taxes
          _buildBillRow(
            'Taxes & Service GST (${AppConstants.taxPercentage.toInt()}%)',
            CurrencyFormatter.format(cartState.taxAmount),
          ),

          // Platform / Visiting charge
          _buildBillRow(
            'Visiting & Spa Setup Fee',
            CurrencyFormatter.format(cartState.platformFee),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.borderLight),
          ),

          // Final Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                CurrencyFormatter.format(cartState.finalTotal),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          // Total Savings Highlight
          if (cartState.totalCustomerSavings > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.successBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_outlined, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'You are saving ${CurrencyFormatter.format(cartState.totalCustomerSavings)} on this order!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isGreen ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
