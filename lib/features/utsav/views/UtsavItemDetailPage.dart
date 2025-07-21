import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/listings/views/EnquiryPage.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:myapp/features/utsav/widgets/TermsConditionsBottomSheet.dart';

import '../models/UtsavVoucher.dart';
import 'OrderSummaryPage.dart';

class UtsavItemDetailPage extends StatelessWidget {
  final String title;
  final String location;
  final String imagePath;
  final bool isVerified;

  const UtsavItemDetailPage({
    super.key,
    required this.title,
    required this.location,
    required this.imagePath,
    this.isVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            const AppHeader(
              title: '',
              showDivider: true, // Since it has tabs below
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
                    _buildStatusBar(),

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
            child: Image.asset(
              imagePath,
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
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isVerified)
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
            location,
            style: AppTextStyles.regular14.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
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
            _buildStatusItem('Oct, 15 2025', 'Valid Until'),
            _buildDivider(),
            _buildStatusItem('20 Voucher', 'Available Voucher'),
            _buildDivider(),
            _buildStatusItem('25%', 'Discount'),
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

        // Voucher items
        _buildVoucherItem(context, isFree: true),
        _buildVoucherItem(context, isFree: false, price: '₹15'),
        _buildVoucherItem(context, isFree: true),
        _buildVoucherItem(context, isFree: false, price: '₹15'),
      ],
    );
  }

  Widget _buildVoucherItem(BuildContext context,
      {required bool isFree, String? price}) {
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Voucher worth Rs. 250',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '10 Sep - 10 Oct 2025',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.replay,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Maximum Uses: 5 Times',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
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
                                const TermsConditionsBottomSheet(),
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
                          _handleClaimVoucher(context, isFree, price);
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
                          isFree ? 'Claim Free' : 'Claim ${price ?? ""}',
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

  void _handleClaimVoucher(BuildContext context, bool isFree, String? price) {
    // Create a voucher object based on the displayed data
    final voucher = UtsavVoucher(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Generate unique ID
      shopName: title,
      shopAddress: location,
      voucherTitle: 'Gift Voucher worth Rs. 500',
      voucherValue: 500,
      status: 'available',
      quantity: 1,
      expiryDate: DateTime.now().add(const Duration(days: 365)),
    );

    // If this is a paid voucher, we would handle payment here
    if (!isFree && price != null) {
      // Payment flow would go here
      // For now, we'll just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Processing payment of $price...'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to order summary page for claiming process
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryPage(voucher: voucher),
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
              onPressed: () {},
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
                      builder: (context) => const EnquiryPage(
                            clinicName: 'Jiva Ayurvedic Clinic',
                            category: 'Ayurvedic',
                            subCategory: 'Clinic',
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
              onPressed: () {},
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
