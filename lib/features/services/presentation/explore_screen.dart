import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../home/presentation/widgets/featured_service_card.dart';
import '../../home/providers/home_provider.dart';
import '../providers/services_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  static const List<String> suggestedKeywords = [
    'Dry Massage',
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
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(exploreFilterProvider);
    final services = ref.watch(filteredServicesProvider);
    final categories = ref.watch(categoriesProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: context.canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                  onPressed: () {
                    _focusNode.unfocus();
                    context.pop();
                  },
                )
              : null,
          title: Text(
            'Search Massages',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: Column(
          children: [
            // Clean Search Bar Header (No Three-Dot / Tune Filter Button)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              color: AppColors.surface,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _focusNode.hasFocus ? AppColors.primary : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
                      onChanged: (val) {
                        ref.read(exploreFilterProvider.notifier).setSearchQuery(val);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        hintText: 'Search 10 luxury therapies, packages & relief...',
                        hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
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
                            selectedColor: AppColors.primaryLight,
                            backgroundColor: AppColors.surface,
                            side: BorderSide(
                              color: isAll ? AppColors.primary : AppColors.border,
                              width: isAll ? 1.4 : 1,
                            ),
                            labelStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: isAll ? FontWeight.w800 : FontWeight.w600,
                              color: isAll ? AppColors.primary : AppColors.textSecondary,
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
                          selectedColor: AppColors.primaryLight,
                          backgroundColor: AppColors.surface,
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 1.4 : 1,
                          ),
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
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

            // Results List
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
                  : ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                      children: [
                        // Popular Searches tags inside scroll view if query empty & no active filters
                        if (_searchController.text.isEmpty && !filterState.hasActiveFilters) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border, width: 1),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'POPULAR SEARCHES',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: suggestedKeywords.map((tag) {
                                    return InkWell(
                                      onTap: () {
                                        _searchController.text = tag;
                                        ref.read(exploreFilterProvider.notifier).setSearchQuery(tag);
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceMuted,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.border, width: 0.8),
                                        ),
                                        child: Text(
                                          tag,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],

                        Text(
                          '${services.length} ${services.length == 1 ? 'Therapy' : 'Therapies'} Found',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...services.map((service) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FeaturedServiceCard(
                              service: service,
                              isHorizontal: false,
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
