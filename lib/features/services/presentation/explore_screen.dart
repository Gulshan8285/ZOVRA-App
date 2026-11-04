import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../home/presentation/widgets/featured_service_card.dart';
import '../../home/providers/home_provider.dart';
import '../providers/services_provider.dart';
import 'widgets/service_filter_sheet.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const List<String> suggestedKeywords = [
    'Full Body Massage',
    'Deep Tissue',
    'Swedish Massage',
    '60 Minute Massage',
    'Couple Massage',
    'Relaxation Massage',
    'Aromatherapy',
    'Sports Massage',
    'Foot Reflexology',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(exploreFilterProvider);
    final services = ref.watch(filteredServicesProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Explore Massages',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Glass Search & Filter Box
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.5))),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGlassCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _focusNode.hasFocus ? AppColors.primary : AppColors.borderGlass.withOpacity(0.4),
                            width: 1.2,
                          ),
                          boxShadow: _focusNode.hasFocus ? AppColors.electricGlow : null,
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          onChanged: (val) {
                            ref.read(exploreFilterProvider.notifier).setSearchQuery(val);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Search massages, durations, packages...',
                            hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13.5),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                                    onPressed: () {
                                      _searchController.clear();
                                      ref.read(exploreFilterProvider.notifier).setSearchQuery('');
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => ServiceFilterSheet.show(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: filterState.hasActiveFilters ? AppColors.primaryLight : AppColors.surfaceGlassCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: filterState.hasActiveFilters ? AppColors.primary : AppColors.borderGlass.withOpacity(0.4),
                            width: 1.2,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: filterState.hasActiveFilters ? AppColors.primary : Colors.white,
                              size: 20,
                            ),
                            if (filterState.hasActiveFilters)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Category Chips Carousel
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isAll = filterState.selectedCategoryId == null;
                        return ChoiceChip(
                          label: const Text('All Massages'),
                          selected: isAll,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceGlassCard,
                          side: BorderSide(color: isAll ? AppColors.primary : AppColors.border),
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isAll ? AppColors.textOnPrimary : Colors.white,
                          ),
                          onSelected: (_) {
                            ref.read(exploreFilterProvider.notifier).selectCategory(null);
                          },
                        );
                      }
                      final cat = categories[index - 1];
                      final isSelected = filterState.selectedCategoryId == cat.id;
                      return ChoiceChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceGlassCard,
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected ? AppColors.textOnPrimary : Colors.white70,
                        ),
                        onSelected: (_) {
                          ref.read(exploreFilterProvider.notifier).selectCategory(cat.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Suggested & Popular Searches when query is empty
          if (_searchController.text.isEmpty && !filterState.hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.backgroundSecondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POPULAR SEARCHES',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: suggestedKeywords.map((tag) {
                      return InkWell(
                        onTap: () {
                          _searchController.text = tag;
                          ref.read(exploreFilterProvider.notifier).setSearchQuery(tag);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGlassCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderGlass.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.trending_up_rounded, size: 13, color: AppColors.primary),
                              const SizedBox(width: 5),
                              Text(
                                tag,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Results list
          Expanded(
            child: services.isEmpty
                ? EmptyView(
                    icon: Icons.search_off_rounded,
                    title: 'No Matching Massages',
                    subtitle: 'Try searching with different keywords or reset your filters.',
                    actionText: 'Reset Filters',
                    onAction: () {
                      _searchController.clear();
                      ref.read(exploreFilterProvider.notifier).resetFilters();
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                    itemCount: services.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return FeaturedServiceCard(
                        service: services[index],
                        isHorizontal: false,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
