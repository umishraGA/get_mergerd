import 'package:flutter/material.dart';
import 'package:myapp/features/utsav/utils/VoucherUtils.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../models/UtsavVoucher.dart';
import 'VoucherDetailPage.dart';

class MyUtsavVouchersPage extends StatefulWidget {
  const MyUtsavVouchersPage({super.key});

  @override
  State<MyUtsavVouchersPage> createState() => _MyUtsavVouchersPageState();
}

class _MyUtsavVouchersPageState extends State<MyUtsavVouchersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with back button and title
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const AppHeader(
                    title: 'My Utsav Vouchers',
                    showDivider: true,
                  ),
                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.black,
                    dividerColor: const Color(0xFFEEEEEE),
                    indicatorColor: Colors.red,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Available'),
                      Tab(text: 'Redeemed'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAvailableVouchersTab(),
                  _buildRedeemedVouchersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableVouchersTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _buildVoucherCard(
          title: 'Gift Voucher worth Rs. 500',
          validUntil: '30 days',
          status: 'Active',
          onTap: () {
            // Navigate to voucher detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoucherDetailPage(
                  voucher: UtsavVoucher(
                    id: '1',
                    shopName: 'SSR Ayurvedic and Panchkarma Clinic',
                    shopAddress: 'Shop No. 123, Example Street',
                    voucherTitle: 'Gift Voucher worth Rs. 500',
                    voucherValue: 500,
                    status: 'available',
                    voucherCode: "0091993",
                    voucherPin: "123456",
                    claimedDate: DateTime.now(),
                    quantity: 1,
                    expiryDate: DateTime.now().add(const Duration(days: 30)),
                  ),
                ),
              ),
            );
          },
        ),
        _buildVoucherCard(
          title: 'Gift Voucher worth Rs. 500',
          validUntil: '30 days',
          status: 'Active',
          onTap: () {
            // Navigate to voucher detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoucherDetailPage(
                  voucher: UtsavVoucher(
                    id: '1',
                    shopName: 'SSR Ayurvedic and Panchkarma Clinic',
                    shopAddress: 'Shop No. 123, Example Street',
                    voucherTitle: 'Gift Voucher worth Rs. 500',
                    voucherValue: 500,
                    status: 'available',
                    voucherCode: "0091993",
                    voucherPin: "123456",
                    claimedDate: DateTime.now(),
                    quantity: 1,
                    expiryDate: DateTime.now().add(const Duration(days: 30)),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRedeemedVouchersTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _buildVoucherCard(
          title: 'Gift Voucher worth Rs. 500',
          validUntil: '30 days',
          status: 'Redeemed',
          onTap: () {
            // Navigate to voucher detail page
          },
        ),
      ],
    );
  }

  Widget _buildVoucherCard({
    required String title,
    required String validUntil,
    required String status,
    required VoidCallback onTap,
  }) {
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    // Main voucher content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '₹500',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF16C47F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '₹500 × 1 voucher',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (status.toLowerCase() == 'redeemed') ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Redeemed',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF16C47F),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'SSR Ayurvedic and Panchkarma Clinic',
                            style: TextStyle(
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

                    // Bottom section with "Details" link
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: onTap,
                            child: const Row(
                              children: [
                                Text(
                                  'Details',
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

                          // Valid until date
                          Text(
                            'Valid: $validUntil',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}

// Using the shared voucher clipper and painter from VoucherUtils.dart
