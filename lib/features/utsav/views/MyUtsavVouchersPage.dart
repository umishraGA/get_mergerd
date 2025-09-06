import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myapp/features/utsav/utils/VoucherUtils.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../models/UtsavVoucher.dart';
import '../models/RedeemHistoryModels.dart';
import '../UtsavViewModel.dart';
import '../UtsavRepository.dart';
import '../../../utils/dio/api_service.dart';
import 'VoucherDetailPage.dart';

class MyUtsavVouchersPage extends StatefulWidget {
  const MyUtsavVouchersPage({super.key});

  @override
  State<MyUtsavVouchersPage> createState() => _MyUtsavVouchersPageState();
}

class _MyUtsavVouchersPageState extends State<MyUtsavVouchersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late UtsavViewModel _viewModel;
  
  List<RedeemHistoryItem> _redeemHistory = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _viewModel = UtsavViewModel(
      repository: UtsavRepository(apiService: ApiService()),
    );
    _loadRedeemHistory();
  }

  Future<void> _loadRedeemHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _viewModel.getRedeemHistory();

      setState(() {
        _redeemHistory = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load vouchers: ${e.toString()}';
        _isLoading = false;
      });
    }
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
              child: _isLoading
                  ? _buildVouchersShimmer()
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadRedeemHistory,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : TabBarView(
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
    final availableVouchers = _redeemHistory
        .where((item) => item.hasAvailableCoupons)
        .toList();

    if (availableVouchers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No available vouchers',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: availableVouchers.length,
      itemBuilder: (context, index) {
        final item = availableVouchers[index];
        return _buildVoucherCard(
          item: item,
          status: 'Available',
          onTap: () {
            _navigateToVoucherDetail(item, false);
          },
        );
      },
    );
  }

  Widget _buildRedeemedVouchersTab() {
    final redeemedVouchers = _redeemHistory
        .where((item) => item.hasRedeemedCoupons)
        .toList();

    if (redeemedVouchers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No redeemed vouchers',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: redeemedVouchers.length,
      itemBuilder: (context, index) {
        final item = redeemedVouchers[index];
        return _buildVoucherCard(
          item: item,
          status: 'Redeemed',
          onTap: () {
            _navigateToVoucherDetail(item, true);
          },
        );
      },
    );
  }

  void _navigateToVoucherDetail(RedeemHistoryItem item, bool isRedeemed) {
    final availableCodes = isRedeemed ? item.redeemedCoupons : item.availableCoupons;
    final firstCode = availableCodes.isNotEmpty ? availableCodes.first : null;


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoucherDetailPage(
          voucher: UtsavVoucher(
            id: item.user,
            shopName: 'Business', // You might need to fetch business name
            shopAddress: 'Business Address',
            voucherTitle: item.couponId.title,
            voucherValue: (item.couponId.fixedValue ?? 0).toDouble(),
            status: isRedeemed ? 'redeemed' : 'available',
            voucherCode: firstCode?.code ?? '',
            voucherPin: '123456', // Default PIN
            claimedDate: item.createdAt,
            quantity: isRedeemed ? item.usedCoupon : item.balanceCoupon,
            expiryDate: item.couponId.expiryDate,
          ),
          customerId: item.user,
          couponId: item.id,
        ),
      ),
    );
  }

  Widget _buildVoucherCard({
    required RedeemHistoryItem item,
    required String status,
    required VoidCallback onTap,
  }) {
    final title = item.couponId.title;
    final validUntil = item.couponId.formattedExpiryDate;
    final displayValue = item.displayValue;
    final quantity = status == 'Redeemed' ? item.usedCoupon : item.balanceCoupon;
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
                                child: Text(
                                  displayValue,
                                  style: const TextStyle(
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
                                child: Text(
                                  '$displayValue × $quantity voucher'
                                      '${quantity > 1 ? 's' : ''}',
                                  style: const TextStyle(
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
                          Text(
                            title,
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

  Widget _buildVouchersShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: 5, // Show 5 shimmer voucher cards
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          height: 160,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
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
            ),
          ),
        );
      },
    );
  }
}

// Using the shared voucher clipper and painter from VoucherUtils.dart
