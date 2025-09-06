import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/listings/views/EnquiryPage.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:myapp/features/utsav/widgets/TermsConditionsBottomSheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/UtsavVoucher.dart';
import '../models/BusinessCouponsModels.dart';
import '../models/CategoryCouponsModels.dart' as CategoryModels;
import '../UtsavViewModel.dart';
import '../UtsavRepository.dart';
import '../../../utils/dio/api_service.dart';
import 'OrderSummaryPage.dart';
import 'CouponDetailPage.dart';

class UtsavItemDetailPage extends StatefulWidget {
  final String title;
  final String location;
  final String imagePath;
  final bool isVerified;
  final String businessId;
  final String categoryId;
  final CategoryModels.BusinessInfo? businessInfo;

  const UtsavItemDetailPage({
    super.key,
    required this.title,
    required this.location,
    required this.imagePath,
    required this.businessId,
    required this.categoryId,
    this.isVerified = true,
    this.businessInfo,
  });

  @override
  State<UtsavItemDetailPage> createState() => _UtsavItemDetailPageState();
}

class _UtsavItemDetailPageState extends State<UtsavItemDetailPage> {
  late final UtsavViewModel _viewModel;
  List<BusinessCoupon> _coupons = [];
  String? _deeplinkUrl;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _viewModel = UtsavViewModel(
        repository: UtsavRepository(apiService: ApiService()));
    _loadBusinessCoupons();
  }

  Future<void> _loadBusinessCoupons() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final request = BusinessCouponsRequest(
        businessid: widget.businessId,
        categoryid: widget.categoryId,
      );

      final response = await _viewModel.getBusinessCoupons(request);

      setState(() {
        _coupons = response.coupons;
        _deeplinkUrl = response.data?.deeplinkurl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load coupons: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            AppHeader(
              title: '',
              showDivider: true, // Since it has tabs below
              showSearch: false,
              shareText: 'Check out amazing vouchers at ${widget.title}!',
              shareUrl: _deeplinkUrl ?? 'https://happeningbazar.com',
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main image and clinic info
                    _buildClinicHeader(context),

                    // Status bar with voucher information
                    // _buildStatusBar(),
                    SizedBox(height: 16),

                    _buildCallDescription(context),

                    // Available vouchers section
                    _buildVouchersSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black54,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          // Search button
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.black54,
              size: 20,
            ),
          ),
          // Share button
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.share,
              color: Colors.black54,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicHeader(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Clinic image
        Container(
          height: isTablet ? 360 : 250,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: widget.imagePath.startsWith('http')
                ? Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/post_image.png',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        // Clinic title and verification
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (widget.isVerified)
                Image.asset(
                  'assets/images/check_icon.png',
                  width: 24,
                  height: 24,
                ),
            ],
          ),
        ),

        // Location
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.location,
            style: AppTextStyles.regular14.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
    if (_isLoading || _coupons.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF16C47F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final firstCoupon = _coupons.first;
    final availableVouchers = firstCoupon.totaluserAvail ?? 0;
    final discountText = firstCoupon.discountType == 'percentage' 
        ? '${firstCoupon.percentage ?? 0}%'
        : '₹${firstCoupon.fixedvalue ?? 0}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16C47F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatusItem(firstCoupon.expiryDate ?? 'No expiry', 'Valid Until'),
            _buildDivider(),
            _buildStatusItem('$availableVouchers Voucher', 'Available Voucher'),
            _buildDivider(),
            _buildStatusItem(discountText, 'Discount'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildVouchersSection(BuildContext context) {
    if (_isLoading) {
      return _buildVouchersShimmer();
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBusinessCoupons,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_coupons.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'No vouchers available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Available Voucher',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Real voucher items from API
        ..._coupons.map((coupon) => _buildVoucherItem(context, coupon)).toList(),
      ],
    );
  }

  Widget _buildVoucherItem(BuildContext context, BusinessCoupon coupon) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: CustomPaint(
        painter: VoucherPainter(),
        child: ClipPath(
          clipper: VoucherClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                // Voucher content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Left side content with discount icon
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF3340).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_offer,
                          color: Color(0xFFEF3340),
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Voucher details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.title ?? 'Voucher',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _getExpiryText(coupon.expiryDate),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.replay,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Available: ${coupon.totaluserAvail ?? 0} uses',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

                // Bottom section with claim button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) =>
                                TermsConditionsBottomSheet(
                                  title: 'Voucher Details',
                                  description: coupon.description,
                                  redeemDays: coupon.redeemdays,
                                  howToRedeem: coupon.howToRedeem,
                                  terms: coupon.terms,
                                  redeemOnSingleBill: coupon.redeemOnSingleBill,
                                ),
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4976C2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Color(0xFF4976C2),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _handleClaimVoucher(context, coupon);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF3340),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        child: Text(
                          _getClaimButtonText(coupon),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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

  String _getClaimButtonText(BusinessCoupon coupon) {
    if (coupon.vouchertype?.toLowerCase() == 'free') {
      return 'Claim Free';
    } else {
      final discountText = coupon.discountType == 'percentage' 
          ? '${coupon.percentage ?? 0}% Off'
          : 'Rs.${coupon.fixedvalue ?? 0} Off';
      return 'Claim $discountText';
    }
  }

  String _getExpiryText(String? expiryDateString) {
    if (expiryDateString == null || expiryDateString.isEmpty) {
      return 'No expiry';
    }
    
    try {
      // Try to parse the date string
      DateTime expiryDate = DateTime.parse(expiryDateString);
      DateTime now = DateTime.now();
      
      // Calculate difference in days
      int daysDifference = expiryDate.difference(now).inDays;
      
      if (daysDifference < 0) {
        return 'Expired';
      } else if (daysDifference == 0) {
        return 'Expires today';
      } else if (daysDifference == 1) {
        return 'Expires in 1 day';
      } else {
        return 'Expires in $daysDifference days';
      }
    } catch (e) {
      // If parsing fails, return the original string
      return 'Valid till $expiryDateString';
    }
  }

  void _handleClaimVoucher(BuildContext context, BusinessCoupon coupon) {
    // Navigate to coupon detail page for code generation and redemption
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CouponDetailPage(
          coupon: coupon,
          businessName: widget.title,
          businessLocation: widget.location,
          customerId: coupon.user,
          couponId: coupon.id,
        ),
      ),
    );
  }

  Widget _buildTicketCutout(bool isLeft) {
    // Creates the zigzag pattern on the voucher edges
    return CustomPaint(
      size: const Size(10, double.infinity),
      painter: TicketCutoutPainter(isLeft: isLeft),
    );
  }

  void _showVoucherDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: _buildVoucherDetailContent(context),
        );
      },
    );
  }

  Widget _buildVoucherDetailContent(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Voucher Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A76C5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Single voucher applicable text
            const Text(
              'Single voucher applicable per bill.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            // Non refundable point
            const Text(
              'a. Non Refundable.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Validity days section
            const Text(
              'Validity - ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildValidityDay('S', true),
                _buildValidityDay('M', true),
                _buildValidityDay('T', true),
                _buildValidityDay('W', true),
                _buildValidityDay('T', true),
                _buildValidityDay('F', true),
                _buildValidityDay('S', true),
              ],
            ),
            const SizedBox(height: 24),

            // How to redeem section
            const Text(
              'How to Redeem',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Numbered steps with red circles
            _buildRedemptionStep(
              '1',
              'Visit any Wow! China outlet listed on the happening bazar app where E-Gift Vouchers are applicable.',
            ),
            const SizedBox(height: 12),
            _buildRedemptionStep(
              '2',
              'Go to "My Transactions" in the "Account" section on the app',
            ),
            const SizedBox(height: 12),
            _buildRedemptionStep(
              '3',
              'Go to "My Transactions" in the "Account" section on the app',
            ),
            const SizedBox(height: 12),
            _buildRedemptionStep(
              '4',
              'Go to "My Transactions" in the "Account" section on the app',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidityDay(String day, bool isValid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.check,
            size: 14,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFFEF3340),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCallDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _makePhoneCall,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F9D58),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, size: 16),
                  SizedBox(width: 8),
                  Text('Call'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EnquiryPage(
                            clinicName: widget.title,
                            category: 'Business',
                            subCategory: 'Service',
                            businessId: widget.businessId,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBC02D),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: const Text('Enquiry'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: _openGoogleMaps,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4976C2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions, size: 16),
                  SizedBox(width: 8),
                  Text('Direction'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    String? phoneNumber;
    
    // Try to get phone number from business info first (from business-coupons API)
    if (_coupons.isNotEmpty && _coupons.first.businessId?.contactInfo?.phoneNo != null) {
      phoneNumber = _coupons.first.businessId!.contactInfo!.phoneNo!;
    }
    // Fallback to a default or show message if no phone number available
    else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number not available for this business'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot make phone call on this device'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error making phone call: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openGoogleMaps() async {
    String? latitude;
    String? longitude;
    
    // Try to get coordinates from business coupons data (more accurate)
    if (_coupons.isNotEmpty && _coupons.first.businessId?.googleLocation != null) {
      latitude = _coupons.first.businessId!.googleLocation!.latitude;
      longitude = _coupons.first.businessId!.googleLocation!.longitude;
    }
    
    String googleMapsUrl;
    
    // Use coordinates if available, otherwise use address
    if (latitude != null && longitude != null && latitude.isNotEmpty && longitude.isNotEmpty) {
      googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    } else {
      // Fallback to address
      String? address = widget.businessInfo?.locationInfo?.address ?? widget.location;
      if (address != null && address.isNotEmpty) {
        googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location information not available for this business'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
    }
    
    final Uri mapsUri = Uri.parse(googleMapsUrl);
    
    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot open maps on this device'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening maps: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildVouchersShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Available Voucher',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Show 3 shimmer voucher cards
        ...List.generate(3, (index) => _buildVoucherShimmer()),
      ],
    );
  }

  Widget _buildVoucherShimmer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      height: 160,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top section with icon and text
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 14,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Bottom section with buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 16,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketCutoutPainter extends CustomPainter {
  final bool isLeft;

  TicketCutoutPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const dotRadius = 5.0;
    const dotSpacing = 24.0;
    final startX = isLeft ? size.width - dotRadius : 0.0;

    // Draw a series of half circles on the edge
    for (double y = dotSpacing / 2; y < size.height; y += dotSpacing) {
      final rect = Rect.fromCircle(
        center: Offset(startX, y),
        radius: dotRadius,
      );

      // Draw half circle cutouts on the edge
      final startAngle = isLeft ? -90 * (3.14159 / 180) : 90 * (3.14159 / 180);
      canvas.drawArc(
        rect,
        startAngle,
        180 * (3.14159 / 180),
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ));

    final Path dashPath = Path();
    const double dashWidth = 6.0;

    for (double i = 0;
        i < path.computeMetrics().first.length;
        i += dashWidth + gap) {
      dashPath.addPath(
        path.computeMetrics().first.extractPath(i, i + dashWidth),
        Offset.zero,
      );
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom clipper for the voucher shape with circular cutouts on both sides
class VoucherClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 16.0;
    const cutoutRadius = 8.0;
    const cutoutSpace = 20.0; // Space between cutouts

    // Top left corner
    path.moveTo(radius, 0);

    // Top edge
    path.lineTo(size.width - radius, 0);

    // Top right corner
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Right edge with small circular cutouts
    double yRight = radius + cutoutSpace / 2;
    while (yRight < size.height - radius - cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(size.width, yRight - cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(
              center: Offset(size.width, yRight), radius: cutoutRadius),
          -math.pi / 2,
          math.pi,
          false);

      yRight += cutoutSpace;
    }

    // Continue right edge to bottom
    path.lineTo(size.width, size.height - radius);

    // Bottom right corner with rounded edge
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);

    // Bottom edge (straight line)
    path.lineTo(radius, size.height);

    // Bottom left corner with rounded edge
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // Left edge with small circular cutouts (symmetrical to right edge)
    double yLeft = size.height - radius - cutoutSpace / 2;
    while (yLeft > radius + cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(0, yLeft + cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(center: Offset(0, yLeft), radius: cutoutRadius),
          math.pi / 2,
          math.pi,
          false);

      yLeft -= cutoutSpace;
    }

    // Continue left edge to top
    path.lineTo(0, radius);

    // Top left corner
    path.quadraticBezierTo(0, 0, radius, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom painter for the voucher background and border
class VoucherPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEF3340).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const radius = 16.0;
    const cutoutRadius = 8.0;
    const cutoutSpace = 20.0; // Space between cutouts

    // Top left corner
    path.moveTo(radius, 0);

    // Top edge
    path.lineTo(size.width - radius, 0);

    // Top right corner
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Right edge with small circular cutouts
    double yRight = radius + cutoutSpace / 2;
    while (yRight < size.height - radius - cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(size.width, yRight - cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(
              center: Offset(size.width, yRight), radius: cutoutRadius),
          -math.pi / 2,
          math.pi,
          false);

      yRight += cutoutSpace;
    }

    // Continue right edge to bottom
    path.lineTo(size.width, size.height - radius);

    // Bottom right corner with rounded edge
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);

    // Bottom edge (straight line)
    path.lineTo(radius, size.height);

    // Bottom left corner with rounded edge
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // Left edge with small circular cutouts (symmetrical to right edge)
    double yLeft = size.height - radius - cutoutSpace / 2;
    while (yLeft > radius + cutoutSpace / 2) {
      // Draw the line to the cutout
      path.lineTo(0, yLeft + cutoutRadius);

      // Draw the cutout (half circle)
      path.arcTo(
          Rect.fromCircle(center: Offset(0, yLeft), radius: cutoutRadius),
          math.pi / 2,
          math.pi,
          false);

      yLeft -= cutoutSpace;
    }

    // Continue left edge to top
    path.lineTo(0, radius);

    // Top left corner
    path.quadraticBezierTo(0, 0, radius, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for the dashed divider line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
