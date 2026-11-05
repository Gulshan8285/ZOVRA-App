import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/whatsapp_share_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../reviews/providers/reviews_provider.dart';
import '../providers/home_provider.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_grid.dart';
import 'widgets/featured_service_card.dart';
import 'widgets/home_header.dart';
import 'widgets/trust_metrics_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final massageServices = ref.watch(massageServicesProvider);
    final popularServices = ref.watch(popularServicesProvider);
    final trendingServices = ref.watch(trendingServicesProvider);
    final reviews = ref.watch(reviewsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 95),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Location, Live Cart, Unread Bell & Profile
              const HomeHeader(),

              // Urban Company Clean Search Bar (No Filter Tune Icon)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () => context.push('/explore'),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search massage services, therapies and wellness...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Promotional Editorial Banners Carousel
              const BannerCarousel(),

              const SizedBox(height: 18),

              // FEATURED SECTION: Signature 1-Hr Therapies (Exact User Pricing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
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
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.spa_rounded, color: AppColors.primary, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SIGNATURE THERAPIES',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.primaryBorder),
                            ),
                            child: Text(
                              'ALL 1 HR SESSIONS',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Full Body Massage Experiences',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Certified wellness partners arrive with portable massage table, sealed single-use linens & cold-pressed oils.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Horizontal Carousel for the Signature Therapies (Dry ₹849, Swedish ₹1249, Deep Tissue ₹1549, Sports ₹1749, Aroma ₹2049)
              SizedBox(
                height: 300,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: massageServices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return FeaturedServiceCard(
                      service: massageServices[index],
                      isHorizontal: true,
                      width: 260,
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              // 10 Massage Subcategories Grid
              const CategoryGrid(),

              const SizedBox(height: 20),

              // Trust & Quality Standards Banner
              const TrustMetricsBanner(),

              const SizedBox(height: 22),

              // Most Popular Massages
              _buildSectionHeader(
                context,
                title: 'Most Popular Massages',
                subtitle: 'Highly rated by 15,000+ satisfied clients across city',
                onSeeAll: () => context.push('/explore'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: popularServices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return FeaturedServiceCard(
                      service: popularServices[index],
                      isHorizontal: true,
                      width: 260,
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              // Luxury Spa Rituals & Couple Care
              _buildSectionHeader(
                context,
                title: 'Luxury Spa Rituals & Couple Care',
                subtitle: 'Opulent multi-step rejuvenation in the comfort of home',
                onSeeAll: () => context.push('/explore'),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: trendingServices.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FeaturedServiceCard(
                        service: service,
                        isHorizontal: false,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // Verified Customer Testimonials Carousel
              if (reviews.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  title: 'Client Experiences',
                  subtitle: 'Real reviews from verified at-home sessions',
                  onSeeAll: () => context.push('/explore'),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: reviews.take(6).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final rev = reviews[index];
                      return Container(
                        width: 280,
                        padding: const EdgeInsets.all(14),
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
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: i < rev.rating.floor()
                                          ? AppColors.ratingGold
                                          : AppColors.border,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  rev.serviceName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                '"${rev.comment}"',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: AppColors.textPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text(
                                  rev.userName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '• Verified Booking',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // WhatsApp Help & Support Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.whatsapp.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.support_agent_rounded, color: AppColors.whatsapp, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need help choosing a massage?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Our wellness concierge is live 24/7 on WhatsApp',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => WhatsAppShareService.shareApp(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.whatsapp,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Chat',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Row(
              children: [
                Text(
                  'View All',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
