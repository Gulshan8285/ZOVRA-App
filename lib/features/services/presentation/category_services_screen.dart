import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../home/presentation/widgets/featured_service_card.dart';
import '../../home/providers/home_provider.dart';

class CategoryServicesScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryServicesScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(zovraRepositoryProvider);
    final categories = repo.getCategories();
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => categories.first,
    );
    final services = repo.getServicesByCategory(categoryId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          category.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.primary),
            onPressed: () => context.push('/explore'),
          ),
        ],
      ),
      body: services.isEmpty
          ? EmptyView(
              icon: Icons.spa_outlined,
              title: 'No Therapies Found',
              subtitle: 'We are expanding our catalogue in ${category.name} soon.',
              actionText: 'Explore Other Massages',
              onAction: () => context.pop(),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                // Category Banner Card in Glass
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlassCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderGlass.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          category.imageUrl,
                          width: 68,
                          height: 68,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 68,
                            height: 68,
                            color: AppColors.primaryLight,
                            child: const Icon(Icons.spa, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star_rounded, size: 12, color: AppColors.ratingGold),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${category.rating}',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.description,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  '${services.length} ${services.length == 1 ? 'Therapy' : 'Therapies'} Available · Starting ₹${category.startingPrice.toInt()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                ...services.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: FeaturedServiceCard(
                      service: service,
                      isHorizontal: false,
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
