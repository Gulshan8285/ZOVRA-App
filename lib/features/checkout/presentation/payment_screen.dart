import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/zovra_button.dart';
import '../../addresses/providers/address_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../../cart/providers/cart_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> schedulingData;

  const PaymentScreen({super.key, required this.schedulingData});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedMethod = 'UPI_GPAY';
  bool _isProcessing = false;
  final TextEditingController _upiIdController = TextEditingController(text: 'gulshan@okhdfcbank');

  @override
  void dispose() {
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> _processPayment({bool simulateFailure = false}) async {
    setState(() => _isProcessing = true);

    final cartState = ref.read(cartProvider);
    final address = ref.read(addressProvider).selectedAddress;
    final user = ref.read(authProvider).user;

    // Simulate network gateway processing delay
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    if (simulateFailure) {
      setState(() => _isProcessing = false);
      context.push('/checkout/failure');
      return;
    }

    // Generate Transaction ID
    final txnSuffix = DateTime.now().millisecondsSinceEpoch.toString().substring(3);
    final txnId = 'TXN-${_selectedMethod.split('_').first}-$txnSuffix';

    final scheduledDate = DateTime.parse(widget.schedulingData['scheduledDate'] as String);
    final timeSlot = widget.schedulingData['timeSlot'] as String;

    String methodLabel = 'UPI (Google Pay)';
    if (_selectedMethod == 'UPI_PHONEPE') methodLabel = 'UPI (PhonePe)';
    if (_selectedMethod == 'UPI_PAYTM') methodLabel = 'UPI (Paytm)';
    if (_selectedMethod == 'UPI_CUSTOM') methodLabel = 'UPI (${_upiIdController.text.trim()})';
    if (_selectedMethod == 'CARD') methodLabel = 'Credit/Debit Card (Visa)';
    if (_selectedMethod == 'NETBANKING') methodLabel = 'Net Banking (HDFC)';
    if (_selectedMethod == 'COD') methodLabel = 'Pay on Service Delivery (COD)';

    try {
      final booking = await ref.read(bookingsProvider.notifier).createBooking(
            userId: user?.id ?? 'usr_guest',
            items: cartState.items,
            scheduledDate: scheduledDate,
            timeSlot: timeSlot,
            address: address!,
            subtotal: cartState.subtotal,
            serviceDiscount: cartState.serviceDiscount,
            couponDiscount: cartState.couponDiscount,
            couponCode: cartState.appliedCoupon?.code,
            taxAmount: cartState.taxAmount,
            platformFee: cartState.platformFee,
            totalAmount: cartState.finalTotal,
            paymentMethod: methodLabel,
            paymentStatus: _selectedMethod == 'COD' ? 'Pending (COD)' : 'Paid',
            transactionId: txnId,
          );

      setState(() => _isProcessing = false);

      if (mounted) {
        context.go('/checkout/success/${booking.id}');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Select Payment Method',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderGlass),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Payable Amount',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(cartState.finalTotal),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                    ),
                    child: Text(
                      '100% SECURE',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Demo Mode Notice Pill
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceGlassCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.info, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Demo Sandbox: All payments are simulated securely without charging real funds. Production Razorpay & Stripe ready.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SECTION 1: UPI Options
            _buildSectionTitle('UPI (INSTANT & ZERO FEE)'),
            const SizedBox(height: 10),
            _buildPaymentTile(
              id: 'UPI_GPAY',
              title: 'Google Pay',
              subtitle: 'Fastest 1-tap checkout via UPI',
              icon: Icons.account_balance_wallet_rounded,
              iconColor: const Color(0xFF4285F4),
            ),
            const SizedBox(height: 8),
            _buildPaymentTile(
              id: 'UPI_PHONEPE',
              title: 'PhonePe UPI',
              subtitle: 'Pay via linked PhonePe account',
              icon: Icons.payments_rounded,
              iconColor: const Color(0xFF5F259F),
            ),
            const SizedBox(height: 8),
            _buildPaymentTile(
              id: 'UPI_PAYTM',
              title: 'Paytm UPI',
              subtitle: 'Pay via Paytm UPI or Wallet',
              icon: Icons.account_balance_wallet_outlined,
              iconColor: const Color(0xFF00BAF2),
            ),
            const SizedBox(height: 8),
            _buildPaymentTile(
              id: 'UPI_CUSTOM',
              title: 'Enter Other UPI ID',
              subtitle: 'VPA: username@bank',
              icon: Icons.alternate_email_rounded,
              iconColor: AppColors.primary,
            ),

            if (_selectedMethod == 'UPI_CUSTOM') ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextField(
                  controller: _upiIdController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. mobile@upi or name@okaxis',
                    prefixIcon: Icon(Icons.verified_user_rounded, color: AppColors.success, size: 18),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // SECTION 2: Cards
            _buildSectionTitle('CREDIT / DEBIT CARDS'),
            const SizedBox(height: 10),
            _buildPaymentTile(
              id: 'CARD',
              title: 'Credit or Debit Card',
              subtitle: 'Visa, MasterCard, RuPay & American Express',
              icon: Icons.credit_card_rounded,
              iconColor: AppColors.primary,
            ),

            const SizedBox(height: 20),

            // SECTION 3: Net Banking
            _buildSectionTitle('NET BANKING'),
            const SizedBox(height: 10),
            _buildPaymentTile(
              id: 'NETBANKING',
              title: 'Net Banking',
              subtitle: 'HDFC, ICICI, SBI, Axis, Kotak & 50+ Banks',
              icon: Icons.account_balance_rounded,
              iconColor: const Color(0xFF0D9488),
            ),

            const SizedBox(height: 20),

            // SECTION 4: Cash on Delivery
            _buildSectionTitle('PAY AFTER SERVICE'),
            const SizedBox(height: 10),
            _buildPaymentTile(
              id: 'COD',
              title: 'Pay After Service Delivery (COD)',
              subtitle: 'Pay via Cash or QR code once service is completed',
              icon: Icons.handshake_rounded,
              iconColor: AppColors.success,
            ),

            const SizedBox(height: 24),

            // Test Failure Flow trigger for full testing
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.bug_report_outlined, size: 16, color: AppColors.textMuted),
                label: Text(
                  'Test Payment Failure Screen Flow',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () => _processPayment(simulateFailure: true),
              ),
            ),
          ],
        ),
      ),

      // Bottom Bar to complete payment
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceGlassCard,
            border: const Border(top: BorderSide(color: AppColors.borderGlass)),
            boxShadow: AppColors.glassShadow,
          ),
          child: ZovraButton(
            text: _selectedMethod == 'COD'
                ? 'Confirm Booking (Pay Later)'
                : 'Pay ${CurrencyFormatter.format(cartState.finalTotal)}',
            isLoading: _isProcessing,
            icon: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 18),
            onPressed: _isProcessing ? null : () => _processPayment(simulateFailure: false),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildPaymentTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _selectedMethod == id;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryLight.withOpacity(0.5) : AppColors.surfaceGlassCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderGlass,
          width: isSelected ? 1.6 : 1,
        ),
        boxShadow: isSelected ? AppColors.electricGlow : null,
      ),
      child: ListTile(
        onTap: () => setState(() => _selectedMethod = id),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
          color: isSelected ? AppColors.primary : AppColors.border,
          size: 22,
        ),
      ),
    );
  }
}

