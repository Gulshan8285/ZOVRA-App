import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../providers/support_provider.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Booking';
  String? _selectedBookingId;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Booking',
    'Payment',
    'Service Quality',
    'Refund',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final user = ref.read(authProvider).user;
    await ref.read(supportProvider.notifier).createTicket(
          userId: user?.id ?? 'usr_guest',
          category: _selectedCategory,
          subject: _subjectController.text.trim(),
          message: _messageController.text.trim(),
          bookingId: _selectedBookingId,
        );

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Support ticket created. Our team will respond shortly.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(bookingsProvider).bookings;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Create Support Ticket',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Issue Category *',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primaryLight,
                    backgroundColor: AppColors.surfaceMuted,
                    labelStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              if (bookings.isNotEmpty) ...[
                Text(
                  'Related Booking (Optional)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedBookingId,
                  decoration: const InputDecoration(
                    hintText: 'Select booking if applicable',
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None / General Issue')),
                    ...bookings.map((b) => DropdownMenuItem(
                          value: b.id,
                          child: Text('#${b.id} (${b.items.first.service.name})'),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedBookingId = val),
                ),
                const SizedBox(height: 20),
              ],

              Text(
                'Subject *',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Refund inquiry or reschedule request',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter subject' : null,
              ),

              const SizedBox(height: 20),

              Text(
                'Detailed Description *',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Explain the issue in detail so we can resolve it quickly...',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter message' : null,
              ),

              const SizedBox(height: 32),

              ZovraButton(
                text: 'Submit Ticket',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

