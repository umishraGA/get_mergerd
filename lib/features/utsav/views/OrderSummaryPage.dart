import 'package:flutter/material.dart';
import 'package:myapp/features/utsav/utils/VoucherUtils.dart';
import 'package:myapp/features/utsav/views/MyUtsavVouchersPage.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:myapp/features/utsav/widgets/TermsConditionsBottomSheet.dart';
import 'package:provider/provider.dart';

import '../models/UtsavVoucher.dart';
import '../providers/UtsavVoucherProvider.dart';

class OrderSummaryPage extends StatelessWidget {
  final UtsavVoucher voucher;

  const OrderSummaryPage({
    super.key,
    required this.voucher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          const AppHeader(
            title: 'Order Summary',
          ),
          // Shop details
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  voucher.shopName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    voucher.shopAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Voucher details card
          _buildVoucherCard(context),

          const SizedBox(
            height: 30,
          ),

          // Claim voucher button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              // width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _claimVoucher(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF3340),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Claim Voucher',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Terms and conditions
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: GestureDetector(
              onTap: () {
                // Show terms and conditions dialog
                _showTermsDialog(context);
              },
              child: const Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4976C2),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: CustomPaint(
        painter: VoucherPainter(),
        child: ClipPath(
          clipper: VoucherClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Amount Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Gift Voucher worth Rs. ${voucher.voucherValue.toInt()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '₹${voucher.voucherValue.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Quantity text
                      Text(
                        '₹${voucher.voucherValue.toInt()} × ${voucher.quantity} voucher(s)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Dotted divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomPaint(
                    painter: DashedLinePainter(),
                    size: const Size(double.infinity, 1),
                  ),
                ),
                // To Pay Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'To pay',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '₹${voucher.voucherValue.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _claimVoucher(BuildContext context) {
    // Use the provider to claim the voucher
    try {
      // Claim the voucher directly without provider
      final claimedVoucher = voucher.claimVoucher();

      // Add to claimed vouchers in the provider
      Provider.of<UtsavVoucherProvider>(context, listen: false)
          .addAvailableVoucher(claimedVoucher);

      // Show a success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Voucher claimed successfully!'),
      //     backgroundColor: Colors.green,
      //   ),
      // );

      // Navigate to voucher detail page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyUtsavVouchersPage(),
        ),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to claim voucher: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showTermsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const TermsConditionsBottomSheet(),
    );
  }
}

// Using the shared voucher clipper and painter from VoucherUtils.dart
