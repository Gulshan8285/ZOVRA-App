import 'dart:ui';
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

  const ServiceDetailScreen({super.key, required this.serviceId});

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
          child: Text('Massage service not found.', style: TextStyle(color: Colors.white70)),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Large Editorial Image & Glass Controls
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlassCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGlassCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share_rounded, color: AppColors.primary, size: 19),
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
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    service.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceMuted),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        'ZOVRA.com',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Details
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background,
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
                            border: Border.all(color: AppColors.success.withOpacity(0.4)),
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
                      color: Colors.white,
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
                  Divider(color: AppColors.border.withOpacity(0.6)),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    'About this Therapy',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
                      color: AppColors.surfaceGlassCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderGlass.withOpacity(0.4)),
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
                                color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...service.packages.map((pkg) {
                      final isSelected = _selectedPackage?.id == pkg.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.12) : AppColors.surfaceGlassCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.borderGlass.withOpacity(0.3),
                            width: isSelected ? 1.8 : 1,
                          ),
                          boxShadow: isSelected ? AppColors.electricGlow : null,
                        ),
                        child: InkWell(
                          onTap: () => setState(() => _selectedPackage = pkg),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  color: isSelected ? AppColors.primary : AppColors.textMuted,
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
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryLight,
                                              borderRadius: BorderRadius.circular(4),
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGlassCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderGlass.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: service.preparationInstructions.map((instruction) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 16),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    instruction,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      height: 1.35,
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

                  // What's Included Section
                  if (service.whatsIncluded.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'What\'s Included',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...service.whatsIncluded.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.success,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // Add-on Services Section
                  if (service.addOns.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Available Add-ons',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...service.addOns.map((addon) {
                      final isChecked = _selectedAddOnIds.contains(addon.id);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isChecked ? AppColors.primary.withOpacity(0.08) : AppColors.surfaceGlassCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isChecked ? AppColors.primary : AppColors.borderGlass.withOpacity(0.3),
                            width: isChecked ? 1.4 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          value: isChecked,
                          activeColor: AppColors.primary,
                          checkColor: AppColors.textOnPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedAddOnIds.add(addon.id);
                              } else {
                                _selectedAddOnIds.remove(addon.id);
                              }
                            });
                          },
                          title: Text(
                            addon.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            addon.description,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          secondary: Text(
                            '+${CurrencyFormatter.format(addon.price)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],

                  // Benefits Section
                  if (service.benefits.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Therapeutic Benefits',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...service.benefits.map((benefit) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.ratingGold,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // FAQs Section
                  if (service.faqs.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Frequently Asked Questions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...service.faqs.map((faq) {
                      final question = faq['q'] ?? faq['question'] ?? '';
                      final answer = faq['a'] ?? faq['answer'] ?? '';
                      return Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Text(
                            question,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                answer,
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
                    }),
                  ],

                  // Customer Reviews Preview
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Verified Reviews (${service.reviewCount})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push('/reviews/${service.id}'),
                        child: Text(
                          'View All',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (serviceReviews.isNotEmpty) ...[
                    ...serviceReviews.take(2).map((rev) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGlassCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderGlass.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                RatingChip(rating: rev.rating, compact: true),
                                const SizedBox(width: 8),
                                Text(
                                  rev.userName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              rev.comment,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Bar with Glass Dock
      bottomNavigationBar: SafeArea(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlass.withOpacity(0.9),
                border: Border(top: BorderSide(color: AppColors.borderGlass.withOpacity(0.3))),
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
                            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textOnPrimary, size: 18),
                            onPressed: () => context.push('/cart'),
                          )
                        : ZovraButton(
                            text: 'Book Therapy',
                            icon: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.textOnPrimary, size: 18),
                            onPressed: () {
                              ref.read(cartProvider.notifier).addToCart(
                                    service: service,
                                    package: _selectedPackage,
                                    addOns: selectedAddOns,
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${service.name} added to cart!'),
                                  backgroundColor: AppColors.surface,
                                  action: SnackBarAction(
                                    label: 'View Cart',
                                    textColor: AppColors.primary,
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
