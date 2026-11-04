import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/cart_item.dart';
import '../../providers/cart_provider.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlassCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGlass.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.service.imageUrl,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 68,
                    height: 68,
                    color: AppColors.surfaceMuted,
                    child: const Icon(Icons.spa, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.service.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    if (item.selectedPackage != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Package: ${item.selectedPackage!.title}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          CurrencyFormatter.format(item.unitPrice),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        if (item.unitOriginalPrice > item.unitPrice) ...[
                          const SizedBox(width: 6),
                          Text(
                            CurrencyFormatter.format(item.unitOriginalPrice),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Quantity Stepper
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 14, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28),
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .updateQuantity(item.id, item.quantity - 1);
                      },
                    ),
                    Text(
                      '${item.quantity}',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28),
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .updateQuantity(item.id, item.quantity + 1);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Selected Add-ons Badges if present
          if (item.selectedAddOns.isNotEmpty) ...[
            const SizedBox(height: 10),
            Divider(height: 12, color: AppColors.border.withOpacity(0.6)),
            Text(
              'Add-ons:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: item.selectedAddOns.map((addon) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '+ ${addon.name} (${CurrencyFormatter.format(addon.price)})',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
