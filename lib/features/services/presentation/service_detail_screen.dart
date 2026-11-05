import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/whatsapp_share_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/rating_chip.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../../data/models/service_item.dart';
import '../../cart/providers/cart_provider.dart';
import '../../home/providers/home_provider.dart';
import '../../reviews/providers/reviews_provider.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String? heroTag;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    this.heroTag,
  });

  @override
  ConsumerState<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  ServicePackage? _selectedPackage;
  final Set<String> _selectedAddOnIds = {};

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(zovraRepositoryProvider);
    final service = repo.getServiceById(widget.serviceId);
    final cartState = ref.watch(cartProvider);

    if (service == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Massage Details')),
        body: const Center(
          child: Text('Massage service not found.', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    // Default package selection
    _selectedPackage ??= service.packages.isNotEmpty ? service.packages.first : null;

    final selectedAddOns =
        service.addOns.where((a) => _selectedAddOnIds.contains(a.id)).toList();

    // Compute active pricing based on selected package and add-ons
    final basePrice = _selectedPackage != null
        ? _selectedPackage!.discountedPrice
        : service.discountedPrice;
    final baseOriginalPrice = _selectedPackage != null
        ? _selectedPackage!.originalPrice
        : service.originalPrice;
    final addOnsPrice =
        selectedAddOns.fold(0.0, (sum, addon) => sum + addon.price);
    final currentPrice = basePrice + addOnsPrice;
    final currentOriginalPrice = baseOriginalPrice + addOnsPrice;

    // Check if this service is in cart
    final inCartItems =
        cartState.items.where((i) => i.service.id == service.id).toList();
    final quantityInCart = inCartItems.fold(0, (sum, i) => sum + i.quantity);

    final serviceReviews = ref.watch(serviceReviewsProvider(service.id));

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // App Bar with Large Editorial Image & Clean Controls
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.surface,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, color: AppColors.whatsapp, size: 19),
                      onPressed: () {
                        WhatsAppShareService.shareService(
                          serviceName: service.name,
                          price: currentPrice,
                          durationMinutes: service.durationMinutes,
                        );
                      },
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: widget.heroTag ?? 'srv_img_${service.id}',
                      child: Image.network(
                        service.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content Details
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating & Review count row
                    Row(
                      children: [
                        RatingChip(
                          rating: service.rating,
                          reviewCount: service.reviewCount,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primaryBorder),
                          ),
                          child: Text(
                            '${service.durationMinutes} mins',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (service.discountPercentage > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.successBorder),
                            ),
                            child: Text(
                              'Save ${service.discountPercentage}%',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Service Name
                    Text(
                      service.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Price Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          CurrencyFormatter.format(currentPrice),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          CurrencyFormatter.format(currentOriginalPrice),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      'About this Therapy',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.fullDescription,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),

                    // The ZOVRA Setup Promise
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.verified_rounded, color: AppColors.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'The ZOVRA Setup Guarantee',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildSetupRow(Icons.check_circle_rounded,
                              'Partner brings portable spa bed & clean disposable linens'),
                          _buildSetupRow(Icons.check_circle_rounded,
                              'Warm, cold-pressed organic oils in sealed bottles'),
                          _buildSetupRow(Icons.check_circle_rounded,
                              'Aromatherapy diffuser & soothing ambient spa audio'),
                          _buildSetupRow(Icons.home_outlined,
                              'You only need a quiet room with space to set up (6x4 ft)'),
                        ],
                      ),
                    ),

                    // Packages / Variants Selection (30m, 60m, 90m)
                    if (service.packages.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Select Duration Package',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...service.packages.map((pkg) {
                        final isSelected = _selectedPackage?.id == pkg.id;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 1.8 : 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => setState(() => _selectedPackage = pkg),
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: isSelected ? AppColors.primary : AppColors.textDisabled,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              pkg.title,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: AppColors.border),
                                              ),
                                              child: Text(
                                                pkg.durationText,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (pkg.description.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            pkg.description,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(pkg.discountedPrice),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],

                    // Preparation Instructions Section
                    if (service.preparationInstructions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Preparation Instructions',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: service.preparationInstructions.map((instruction) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline_rounded,
                                      color: AppColors.primary, size: 16),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      instruction,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    // Verified Client Reviews
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Verified Reviews (${serviceReviews.length})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        RatingChip(
                          rating: service.rating,
                          reviewCount: serviceReviews.length,
                          compact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (serviceReviews.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'Be the first to review this soothing therapy.',
                          style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      )
                    else
                      Column(
                        children: serviceReviews.take(3).map((r) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      r.userName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          Icons.star_rounded,
                                          size: 13,
                                          color: i < r.rating.floor()
                                              ? AppColors.ratingGold
                                              : AppColors.border,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  r.comment,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Fixed Bottom Pricing & CTA Dock (Urban Company Clean Style)
        bottomNavigationBar: SafeArea(
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
                      CurrencyFormatter.format(currentPrice),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${_selectedPackage?.title ?? '60 Mins'} · Incl. bed',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: quantityInCart > 0
                      ? ZovraButton(
                          text: 'Go to Cart ($quantityInCart)',
                          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                          onPressed: () => context.push('/cart'),
                        )
                      : ZovraButton(
                          text: 'Book Therapy',
                          icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 18),
                          onPressed: () {
                            ref.read(cartProvider.notifier).addToCart(
                                  service: service,
                                  package: _selectedPackage,
                                  addOns: selectedAddOns,
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${service.name} added to cart!'),
                                backgroundColor: AppColors.dark,
                                action: SnackBarAction(
                                  label: 'View Cart',
                                  textColor: Colors.white,
                                  onPressed: () => context.push('/cart'),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetupRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
