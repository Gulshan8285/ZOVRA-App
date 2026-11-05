import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../home/presentation/widgets/featured_service_card.dart';
import '../../home/providers/home_provider.dart';

class MassageScreen extends ConsumerStatefulWidget {
  const MassageScreen({super.key});

  @override
  ConsumerState<MassageScreen> createState() => _MassageScreenState();
}

class _MassageScreenState extends ConsumerState<MassageScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(zovraRepositoryProvider);
    final categories = repo.getCategories();
    final allServices = repo.getServices();

    final filteredServices = _selectedCategoryId == null
        ? allServices
        : allServices.where((s) => s.categoryId == _selectedCategoryId).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Massage Therapies',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '10 Doorstep therapies · Certified specialists',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Search Massages',
            icon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
            onPressed: () => context.push('/search'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category Pill Chips (Horizontal scrollable, No Three-Dot Filter Button!)
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isAll = _selectedCategoryId == null;
                    return ChoiceChip(
                      label: Text(
                        'All Massages (${allServices.length})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isAll ? FontWeight.w800 : FontWeight.w600,
                          color: isAll ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                      selected: isAll,
                      selectedColor: AppColors.primaryLight,
                      backgroundColor: AppColors.surfaceMuted,
                      side: BorderSide(
                        color: isAll ? AppColors.primary : AppColors.border,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _selectedCategoryId = null),
                    );
                  }

                  final cat = categories[index - 1];
                  final isSelected = _selectedCategoryId == cat.id;

                  return ChoiceChip(
                    label: Text(
                      cat.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primaryLight,
                    backgroundColor: AppColors.surfaceMuted,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _selectedCategoryId = cat.id),
                  );
                },
              ),
            ),
          ),

          // Divider
          const Divider(height: 1, color: AppColors.border),

          // Therapies List
          Expanded(
            child: filteredServices.isEmpty
                ? EmptyView(
                    icon: Icons.spa_outlined,
                    title: 'No Therapies in this category',
                    subtitle: 'Please select another category or view all massages.',
                    actionText: 'View All Massages',
                    onAction: () => setState(() => _selectedCategoryId = null),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 110), // Padding for persistent bottom nav
                    itemCount: filteredServices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      return FeaturedServiceCard(
                        service: service,
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

