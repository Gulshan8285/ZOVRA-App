import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/whatsapp_share_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/rating_chip.dart';
import '../../../../data/models/service_item.dart';
import '../../../cart/providers/cart_provider.dart';

class FeaturedServiceCard extends ConsumerWidget {
  final ServiceItem service;
  final bool isHorizontal;
  final double width;

  const FeaturedServiceCard({
    super.key,
    required this.service,
    this.isHorizontal = true,
    this.width = 270,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final inCart = cartState.items.where((i) => i.service.id == service.id).toList();
    final quantityInCart = inCart.fold(0, (sum, i) => sum + i.quantity);
    final savings = (service.originalPrice - service.discountedPrice).clamp(0.0, double.infinity);

    // Horizontal Carousel Card
    if (isHorizontal) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surfaceGlassCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderGlass.withOpacity(0.35), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => context.push('/service/${service.id}'),
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header with tags & WhatsApp share button
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: Stack(
                  children: [
                    Image.network(
                      service.imageUrl,
                      height: 145,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 145,
                        color: AppColors.surfaceMuted,
                        child: const Icon(Icons.spa, size: 40, color: AppColors.textMuted),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.background.withOpacity(0.85),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Rating Pill on bottom left
                    Positioned(
                      bottom: 8,
                      left: 10,
                      child: RatingChip(
                        rating: service.rating,
                        reviewCount: service.reviewCount,
                        compact: true,
                      ),
                    ),
                    // Duration on bottom right
                    Positioned(
                      bottom: 8,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: AppColors.accentIcyBlue, size: 11),
                            const SizedBox(width: 4),
                            Text(
                              '${service.durationMinutes}m',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Savings badge on top left
                    if (savings > 0)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.success.withOpacity(0.4)),
                          ),
                          child: Text(
                            'Save ${CurrencyFormatter.format(savings)}',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    // WhatsApp Share Icon on top right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          WhatsAppShareService.shareService(
                            serviceName: service.name,
                            price: service.discountedPrice,
                            durationMinutes: service.durationMinutes,
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Icon(
                            Icons.share_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Card Body
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price and Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CurrencyFormatter.format(service.discountedPrice),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            if (service.originalPrice > service.discountedPrice)
                              Text(
                                CurrencyFormatter.format(service.originalPrice),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        // Add Button or Quantity Stepper
                        _buildCartActionButton(context, ref, quantityInCart),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Vertical Full-Width Card (List View)
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGlassCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGlass.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/service/${service.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Details on the left
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingChip(
                          rating: service.rating,
                          reviewCount: service.reviewCount,
                          compact: true,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${service.durationMinutes} mins',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          CurrencyFormatter.format(service.discountedPrice),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (service.originalPrice > service.discountedPrice) ...[
                          Text(
                            CurrencyFormatter.format(service.originalPrice),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Save ${CurrencyFormatter.format(savings)}',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.success,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    if (service.whatsIncluded.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '• ${service.whatsIncluded.first}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Image & Actions stacked on the right
              Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          service.imageUrl,
                          width: 105,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 105,
                            height: 105,
                            color: AppColors.surfaceMuted,
                            child: const Icon(Icons.spa, color: AppColors.textMuted),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            WhatsAppShareService.shareService(
                              serviceName: service.name,
                              price: service.discountedPrice,
                              durationMinutes: service.durationMinutes,
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.share_rounded, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildCartActionButton(context, ref, quantityInCart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartActionButton(BuildContext context, WidgetRef ref, int quantity) {
    if (quantity > 0) {
      return Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                final inCart = ref
                    .read(cartProvider)
                    .items
                    .where((i) => i.service.id == service.id)
                    .toList();
                if (inCart.isNotEmpty) {
                  ref
                      .read(cartProvider.notifier)
                      .updateQuantity(inCart.first.id, inCart.first.quantity - 1);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.remove, size: 14, color: AppColors.primary),
              ),
            ),
            Text(
              '$quantity',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
            InkWell(
              onTap: () {
                final inCart = ref
                    .read(cartProvider)
                    .items
                    .where((i) => i.service.id == service.id)
                    .toList();
                if (inCart.isNotEmpty) {
                  ref
                      .read(cartProvider.notifier)
                      .updateQuantity(inCart.first.id, inCart.first.quantity + 1);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.add, size: 14, color: AppColors.primary),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        ref.read(cartProvider.notifier).addToCart(service: service);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${service.name} added to cart!'),
            duration: const Duration(seconds: 1),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'ADD',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.textOnPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
