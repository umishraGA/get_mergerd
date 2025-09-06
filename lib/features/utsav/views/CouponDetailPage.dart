import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import '../models/BusinessCouponsModels.dart';
import '../models/CouponCodeModels.dart';
import '../UtsavViewModel.dart';
import '../UtsavRepository.dart';
import '../../../utils/dio/api_service.dart';

class CouponDetailPage extends StatefulWidget {
  final BusinessCoupon coupon;
  final String businessName;
  final String businessLocation;
  final String? customerId;
  final String? couponId;

  const CouponDetailPage({
    super.key,
    required this.coupon,
    required this.businessName,
    required this.businessLocation,
    this.customerId,
    this.couponId,
  });

  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  bool _isDetailsExpanded = true;
  String? _couponCode;
  bool _isCodeGenerated = false;
  bool _isGeneratingCode = false;
  bool _isRedeeming = false;
  late final UtsavViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = UtsavViewModel(
        repository: UtsavRepository(apiService: ApiService()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            AppHeader(
              title: '',
              showDivider: false,
              showSearch: false, // Remove search option
              shareText: _isCodeGenerated && _couponCode != null 
                  ? 'Check out this coupon code: $_couponCode for ${widget.businessName}!'
                  : 'Check out this amazing coupon at ${widget.businessName}!',
              shareUrl: '', // No URL for coupon code sharing
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discount offer container
                    _buildDiscountContainer(),
                    
                    const SizedBox(height: 20),
                    
                    // Coupon code section
                    _buildCouponCodeSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Details section
                    _buildDetailsSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Redeem button
                    // _buildRedeemButton(),
                    
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountContainer() {
    final discountText = widget.coupon.discountType == 'percentage' 
        ? 'Flat ${widget.coupon.percentage ?? 0}% off'
        : 'Flat ₹${widget.coupon.fixedvalue ?? 0} off';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discount title
          Text(
            discountText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Coupon description
          Text(
            widget.coupon.description ?? widget.coupon.title ?? 'Special offer',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCodeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Dotted line or code
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _isCodeGenerated ? (_couponCode ?? 'LOADING...') : '••••••••••••',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _isCodeGenerated ? Colors.black87 : Colors.grey,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          
          // Get code button
          ElevatedButton(
            onPressed: _isGeneratingCode ? null : (_isCodeGenerated ? _copyCouponCode : _generateCouponCode),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4976C2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isGeneratingCode
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _isCodeGenerated ? 'Copy' : 'Get code',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
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
                  _isDetailsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
    if (widget.coupon.expiryDate != null) {
      final expiryDate = DateTime.tryParse(widget.coupon.expiryDate!);
      if (expiryDate != null) {
        final formattedDate = '${_getMonthName(expiryDate.month)} ${expiryDate.day}, ${expiryDate.year}';
        details.add('Expires on $formattedDate');
      }
    }
    
    // Add business info
    details.add('${widget.businessName}. ${widget.businessLocation}');
    
    // Add discount details
    final discountText = widget.coupon.discountType == 'percentage' 
        ? 'Get Flat ${widget.coupon.percentage ?? 0}% off'
        : 'Get Flat ₹${widget.coupon.fixedvalue ?? 0} off';
    details.add(discountText);
    
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

  Widget _buildRedeemButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_isCodeGenerated && !_isRedeeming) ? _redeemCoupon : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isCodeGenerated ? const Color(0xFF4976C2) : Colors.grey.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isRedeeming
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Redeeming...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.open_in_new,
                    size: 20,
                    color: _isCodeGenerated ? Colors.white : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Redeem now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isCodeGenerated ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _generateCouponCode() async {
    setState(() {
      _isGeneratingCode = true;
    });

    try {
      final request = GenerateCouponCodeRequest(
        couponId: widget.couponId ?? widget.coupon.id ?? '',
        customerId: widget.customerId ?? 'temp_customer_id',
      );

      final response = await _viewModel.generateCouponCode(request);
      
      if (response.data != null && response.data!.couponcode != null && response.data!.couponcode!.isNotEmpty) {
        final generatedCode = response.data!.couponcode!.first.code;
        if (generatedCode != null) {
          setState(() {
            _couponCode = generatedCode;
            _isCodeGenerated = true;
            _isGeneratingCode = false;
          });
          
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Coupon code generated successfully!'),
                backgroundColor: Color(0xFF16C47F),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          throw Exception('No valid coupon code returned');
        }
      } else {
        throw Exception('Failed to generate coupon code');
      }
    } catch (e) {
      setState(() {
        _isGeneratingCode = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate code: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _copyCouponCode() {
    if (_couponCode != null) {
      Clipboard.setData(ClipboardData(text: _couponCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon code copied to clipboard!'),
          backgroundColor: Color(0xFF16C47F),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _redeemCoupon() async {
    if (_couponCode == null) return;
    
    // Show redeem confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Redeem Coupon'),
          content: Text('Do you want to redeem this coupon at ${widget.businessName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Redeem'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isRedeeming = true;
    });

    try {
      final request = RedeemCouponRequest(
        couponId: widget.coupon.couponId ?? widget.coupon.id ?? '',
        customerId: widget.customerId ?? 'temp_customer_id',
      );

      final response = await _viewModel.redeemCoupon(request);
      
      setState(() {
        _isRedeeming = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coupon redeemed successfully at ${widget.businessName}!'),
            backgroundColor: const Color(0xFF16C47F),
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Navigate back after successful redemption
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isRedeeming = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to redeem coupon: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}