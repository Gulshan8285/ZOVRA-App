import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/zovra_button.dart';
import '../providers/address_provider.dart';

class AddressListScreen extends ConsumerWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressProvider);
    final addresses = addressState.addresses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Saved Addresses',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: addresses.isEmpty
          ? EmptyView(
              icon: Icons.location_off_rounded,
              title: 'No Saved Addresses',
              subtitle: 'Add your home or office address for fast service delivery.',
              actionText: 'Add New Address',
              onAction: () => context.push('/addresses/add'),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final addr = addresses[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: addr.isDefault ? AppColors.primary : AppColors.border,
                      width: addr.isDefault ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                addr.tag == 'Home'
                                    ? Icons.home_rounded
                                    : (addr.tag == 'Office'
                                        ? Icons.apartment_rounded
                                        : Icons.location_on_rounded),
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                addr.tag,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (addr.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'DEFAULT',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32),
                                onPressed: () {
                                  context.push('/addresses/edit/${addr.id}');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 18, color: AppColors.error),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32),
                                onPressed: () {
                                  ConfirmationDialog.show(
                                    context,
                                    title: 'Delete Address?',
                                    message:
                                        'Are you sure you want to remove this saved address (${addr.shortAddress})?',
                                    confirmText: 'Delete',
                                    isDestructive: true,
                                    onConfirm: () {
                                      ref
                                          .read(addressProvider.notifier)
                                          .deleteAddress(addr.id);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        addr.fullAddress,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      if (addr.specialInstructions.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Instructions: ${addr.specialInstructions}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (!addr.isDefault) ...[
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            ref
                                .read(addressProvider.notifier)
                                .setDefault(addr.id);
                          },
                          child: Text(
                            'Set as Default',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.borderLight)),
          ),
          child: ZovraButton(
            text: '+ Add New Address',
            onPressed: () => context.push('/addresses/add'),
          ),
        ),
      ),
    );
  }
}

