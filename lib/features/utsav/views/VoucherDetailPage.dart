import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/dio/api_service.dart';
import '../UtsavRepository.dart';
import '../UtsavViewModel.dart';
import '../models/CouponCodeModels.dart';
import '../models/UtsavVoucher.dart';
import '../utils/VoucherUtils.dart';
import '../widgets/AppHeader.dart';
import '../widgets/TermsConditionsBottomSheet.dart';

/// A page that displays voucher details and allows code generation
class VoucherDetailPage extends StatefulWidget {
  /// The voucher to display details for
  final UtsavVoucher voucher;
  
  /// The customer ID for code generation
  final String? customerId;
  final String? couponId;

  /// Creates a [VoucherDetailPage]
  const VoucherDetailPage({
    super.key,
    required this.voucher,
    this.customerId,
    this.couponId,
  });

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  late UtsavViewModel _viewModel;
  String? _generatedCode;
  String? _generatedPin;
  bool _isGeneratingCode = false;
  bool _codeRevealed = false;
  bool _isDetailsExpanded = false;

  @override
  void initState() {
    super.initState();
    _viewModel = UtsavViewModel(
      repository: UtsavRepository(apiService: ApiService()),
    );
  }

  Future<void> _generateCouponCode() async {
    if (_isGeneratingCode) return;

    setState(() {
      _isGeneratingCode = true;
    });

    try {
      final couponId = widget.couponId ?? widget.voucher.id ?? '';
      final customerId = widget.customerId ?? 'temp_customer_id';
      
      // if (kDebugMode) {
        print('VoucherDetailPage: Generating coupon code with '
            'couponId: $couponId, customerId: $customerId');
      // }
      
      final request = GenerateCouponCodeRequest(
        couponId: couponId,
        customerId: customerId,
      );

      final response = await _viewModel.generateCouponCode(request);

      if (response.data != null &&
          response.data!.couponcode != null &&
          response.data!.couponcode!.isNotEmpty) {
        final generatedCode = response.data!.couponcode!.first.code;
        if (generatedCode != null) {
          setState(() {
            _generatedCode = generatedCode;
            _generatedPin = '123456';
            _codeRevealed = true;
            _isGeneratingCode = false;
          });
        }
      } else {
        _showErrorMessage('Failed to generate coupon code');
        setState(() {
          _isGeneratingCode = false;
        });
      }
    } catch (e) {
      _showErrorMessage('Error generating code: ${e.toString()}');
      setState(() {
        _isGeneratingCode = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          const AppHeader(
            title: 'Order Summary',
            showDivider: true,
            showSearch: false, // Remove search option
          ),
          // Shop details
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  widget.voucher.shopName,
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
                    widget.voucher.shopAddress,
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

          _buildVoucherCodeCard(context),
          // Voucher details card with code and PIN

          // Details section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: _buildDetailsSection(),
          ),

          // Terms and conditions
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) =>
                      const TermsConditionsBottomSheet(),
                );
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

  Widget _buildVoucherCodeCard(BuildContext context) {
    // Format date as "11:26pm, 18 March 2025"
    final dateTime = widget.voucher.claimedDate;
    String formattedDate = '';
    if (dateTime != null) {
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final amPm = dateTime.hour >= 12 ? 'pm' : 'am';
      final minutes = dateTime.minute.toString().padLeft(2, '0');
      final day = dateTime.day;
      final month = _getMonth(dateTime.month);
      final year = dateTime.year;
      formattedDate = '$hour:$minutes$amPm, $day $month $year';
    }

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
                  color: Colors.grey.withValues(alpha: 0.2),
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
                      // Date and claim status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Unclaimed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title and Amount Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.voucher.voucherTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '₹${widget.voucher.voucherValue.toInt()}',
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
                        '₹${widget.voucher.voucherValue.toInt()} × '
                        '${widget.voucher.quantity} voucher(s)',
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
                // Voucher Details Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _codeRevealed
                      ? _buildRevealedCodes()
                      : _buildGetCodeButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGetCodeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isGeneratingCode ? null : _generateCouponCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: _isGeneratingCode
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Generating Code...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                'Get Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildRevealedCodes() {
    return Column(
      children: [
        // Voucher code
        Row(
          children: [
            const SizedBox(
              width: 120,
              child: Text(
                'Voucher Code',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Text(
              ':',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                _buildVoucherIcon(),
                const SizedBox(width: 8),
                Text(
                  _generatedCode ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Voucher PIN
        Row(
          children: [
            const SizedBox(
              width: 120,
              child: Text(
                'Voucher Pin',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Text(
              ':',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                _buildVoucherIcon(),
                const SizedBox(width: 8),
                Text(
                  _generatedPin ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoucherIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(
        Icons.confirmation_number_outlined,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Details header
        GestureDetector(
          onTap: () {
            setState(() {
              _isDetailsExpanded = !_isDetailsExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  _isDetailsExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        
        // Details content
        if (_isDetailsExpanded) ...[
          const SizedBox(height: 12),
          _buildDetailsList(),
        ],
      ],
    );
  }

  Widget _buildDetailsList() {
    final details = <String>[];
    
    // Add expiry date
    if (widget.voucher.expiryDate != null) {
      DateTime? expiryDate;
      if (widget.voucher.expiryDate is String) {
        expiryDate = DateTime.tryParse(widget.voucher.expiryDate as String);
      } else if (widget.voucher.expiryDate is DateTime) {
        expiryDate = widget.voucher.expiryDate as DateTime;
      }
      if (expiryDate != null) {
        final formattedDate =
            '${_getMonth(expiryDate.month)} ${expiryDate.day}, '
            '${expiryDate.year}';
        details.add('Expires on $formattedDate');
      }
    }
    
    // Add business info
    details.add(
        '${widget.voucher.shopName}. ${widget.voucher.shopAddress}');
    
    // Add voucher value
    details.add('Voucher value: ₹${widget.voucher.voucherValue.toInt()}');
    
    // Add quantity
    details.add('Quantity: ${widget.voucher.quantity} voucher(s)');
    
    // Add availability
    details.add('Available to all users.');
    
    // Add minimum spend (if any)
    details.add('No minimum spend required.');
    
    // Add applicable products
    details.add('Offer applies to all products on the landing page.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.map((detail) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 8, right: 12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  String _getMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

// Using the shared voucher clipper and painter from VoucherUtils.dart
