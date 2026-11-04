import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/coupon_model.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../../home/providers/home_provider.dart';

class AdminControlScreen extends ConsumerStatefulWidget {
  const AdminControlScreen({super.key});

  @override
  ConsumerState<AdminControlScreen> createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends ConsumerState<AdminControlScreen> {
  // Coupon Form state
  final TextEditingController _couponCodeController = TextEditingController();
  final TextEditingController _couponTitleController = TextEditingController();
  final TextEditingController _couponDiscountController = TextEditingController(text: '25');
  final TextEditingController _couponMinOrderController = TextEditingController(text: '799');

  @override
  void dispose() {
    _couponCodeController.dispose();
    _couponTitleController.dispose();
    _couponDiscountController.dispose();
    _couponMinOrderController.dispose();
    super.dispose();
  }

  void _showAddCouponDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Create New Coupon',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _couponCodeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'Code (e.g. FESTIVE25)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _couponTitleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _couponDiscountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Discount % (e.g. 25)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _couponMinOrderController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Min Order (₹)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_couponCodeController.text.trim().isNotEmpty) {
                final newCoupon = CouponModel(
                  id: 'coup_${DateTime.now().millisecondsSinceEpoch}',
                  code: _couponCodeController.text.trim().toUpperCase(),
                  title: _couponTitleController.text.trim().isEmpty
                      ? '${_couponDiscountController.text}% Special Discount'
                      : _couponTitleController.text.trim(),
                  description:
                      'Get ${_couponDiscountController.text}% off on bookings above ₹${_couponMinOrderController.text}.',
                  discountType: 'percentage',
                  discountValue: double.tryParse(_couponDiscountController.text) ?? 25.0,
                  minOrderAmount: double.tryParse(_couponMinOrderController.text) ?? 799.0,
                  maxDiscount: 600.0,
                  validTill: DateTime.now().add(const Duration(days: 30)),
                );
                await ref.read(zovraRepositoryProvider).addCoupon(newCoupon);
                if (mounted) {
                  Navigator.of(ctx).pop();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Coupon ${newCoupon.code} created live!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(zovraRepositoryProvider);
    final services = repo.getServices();
    final bookings = ref.watch(bookingsProvider).bookings;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Admin Controls & Testing',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [
              Tab(text: 'Live Bookings'),
              Tab(text: 'Services Catalog'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Live Bookings Status Control
            ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final b = bookings[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '#${b.id}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(b.totalAmount),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        b.items.map((i) => i.service.name).join(', '),
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Change Booking Status Live:',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<BookingStatus>(
                        value: b.status,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: BookingStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status.label,
                              style: TextStyle(color: status.color, fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        onChanged: (newStatus) {
                          if (newStatus != null) {
                            ref
                                .read(bookingsProvider.notifier)
                                .updateBookingStatus(b.id, newStatus);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Booking #${b.id} status changed to ${newStatus.label}'),
                                backgroundColor: AppColors.dark,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            // Tab 2: Services Catalog Management
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manage Services (${services.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    ZovraButton(
                      text: '+ Add Coupon',
                      width: 120,
                      height: 38,
                      onPressed: _showAddCouponDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...services.map((s) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            s.imageUrl,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${CurrencyFormatter.format(s.discountedPrice)} · ${s.isActive ? 'Active' : 'Disabled'}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: s.isActive ? AppColors.success : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: s.isActive,
                          activeColor: AppColors.primary,
                          onChanged: (_) async {
                            await repo.toggleServiceStatus(s.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

