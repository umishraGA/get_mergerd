import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/locationUtils/LocationUtils.dart';
import '../models/UtsavCategory.dart';
import '../models/CategoryCouponsModels.dart' as CategoryModels;
import '../models/CouponBannerModels.dart';
import '../models/SearchModels.dart';
import '../UtsavViewModel.dart';
import '../UtsavRepository.dart';
import '../../../utils/dio/api_service.dart';
import 'UtsavItemDetailPage.dart';

class UtsavCategoryPage extends StatefulWidget {
  final UtsavCategory category;
  final String? searchQuery;

  const UtsavCategoryPage({
    super.key,
    required this.category,
    this.searchQuery,
  });

  @override
  State<UtsavCategoryPage> createState() => _UtsavCategoryPageState();
}

class _UtsavCategoryPageState extends State<UtsavCategoryPage> {
  late final UtsavViewModel _viewModel;
  List<CategoryModels.BusinessInfo> _coupons = [];
  List<CouponBanner> _banners = [];
  bool _isLoading = true;
  bool _isBannerLoading = true;
  String? _errorMessage;
  String _locationAddress = 'Mattyari,Lucknow - 226028';

  @override
  void initState() {
    super.initState();
    _viewModel = UtsavViewModel(
        repository: UtsavRepository(apiService: ApiService()));
    _loadSelectedLocation();
    _loadCoupons();
    _loadBanners();
  }

  Future<void> _loadSelectedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final address = prefs.getString('selected_location_address');
      
      if (address != null) {
        setState(() {
          _locationAddress = address;
        });
      }
    } catch (e) {
      debugPrint('Error loading selected location: $e');
    }
  }

  Future<void> _loadCoupons() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      var coordinates = await LocationUtils.getUserCoordinates();
      var latitude = coordinates[0];
      var longitude = coordinates[1];

      CategoryModels.CategoryCouponsResponse response;

      if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
        // Use search API
        final searchRequest = SearchRequest(
          search: widget.searchQuery!,
          latitude: latitude.toString(),
          longitude: longitude.toString(),
        );
        response = await _viewModel.searchCoupons(searchRequest);
      } else {
        // Use category coupons API
        final request = CategoryModels.CategoryCouponsRequest(
          categoryid: widget.category.id,
          latitude: latitude.toString(),
          longitude: longitude.toString(),
        );
        response = await _viewModel.getCategoryCoupons(request);
      }

      setState(() {
        _coupons = response.data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load coupons: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBanners() async {
    try {
      setState(() {
        _isBannerLoading = true;
      });

      var coordinates = await LocationUtils.getUserCoordinates();
      var latitude = coordinates[0];
      var longitude = coordinates[1];

      final request = CouponBannerRequest(
        categoryId: widget.category.id,
        latitude: latitude,  // You may want to get this from location services
        longitude: longitude, // You may want to get this from location services
      );

      final response = await _viewModel.getCouponBanner(request);

      setState(() {
        _banners = response.data ?? [];
        _isBannerLoading = false;
      });
    } catch (e) {
      setState(() {
        _isBannerLoading = false;
      });
    }
  }

  void _handleSearch(String searchQuery) {
    // Create a temporary category for search results
    final searchCategory = UtsavCategory(
      id: 'search',
      name: 'Search Results',
      imagePath: 'assets/images/utsav/categories/default.png',
    );

    // Navigate to category page with search query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UtsavCategoryPage(
          category: searchCategory,
          searchQuery: searchQuery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with red background
            AppHeader(
              title: widget.searchQuery != null && widget.searchQuery!.isNotEmpty 
                  ? 'Search Results' 
                  : widget.category.name,
              subtitle: _locationAddress,
              showDropdown: true,
              showShare: false,
              onSearchSubmitted: _handleSearch,
            ),

            // Results list (scrollable content)
            Expanded(
              child: _isLoading
                  ? _buildCouponsShimmer()
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
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
                                  onPressed: _loadCoupons,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemCount: _coupons.length + 1, // +1 for header
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              final bannerWidget = _buildBannerAd(context);
                              final showBanner = !_isBannerLoading && _banners.isNotEmpty;
                              
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showBanner) ...[
                                    const SizedBox(height: 10),
                                    bannerWidget,
                                    const SizedBox(height: 10),
                                    const Divider(
                                      height: 1,
                                      color: Color(0xFFEEEEEE),
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                  ],
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      widget.searchQuery != null && widget.searchQuery!.isNotEmpty
                                          ? '${_coupons.length} Results for "${widget.searchQuery}"'
                                          : '${_coupons.length} Results for your Search',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return _buildListingItem(context, _coupons[index - 1]);
                            }
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerAd(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    
    if (_isBannerLoading) {
      return Container(
        height: isTablet ? 360 : 187,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
    
    if (_banners.isEmpty) {
      return const SizedBox.shrink(); // Hide banner section when no banners available
    }
    
    final banner = _banners.first;
    final bannerUrl = banner.mobBanner;
    final bannerBusiness = banner.businessId;
    
    return GestureDetector(
      onTap: () {
        if (bannerBusiness != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UtsavItemDetailPage(
                title: bannerBusiness.locationInfo?.address ?? 'Business',
                location: bannerBusiness.locationInfo?.address ?? 'Location not available',
                imagePath: bannerUrl ?? 'assets/images/post_image.png',
                isVerified: true,
                businessId: bannerBusiness.id ?? '',
                categoryId: widget.category.id,
                // Note: bannerBusiness is CouponBannerModels.BusinessInfo, not CategoryModels.BusinessInfo
              ),
            ),
          );
        }
      },
      child: Container(
        height: isTablet ? 360 : 187,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: bannerUrl != null && bannerUrl.isNotEmpty
              ? Image.network(
                  bannerUrl,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/utsav/banners/limited_time_offer.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/utsav/banners/limited_time_offer.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildListingItem(BuildContext context, CategoryModels.BusinessInfo business) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UtsavItemDetailPage(
              title: business.companyInfo?.companyName ?? 'Business',
              location: business.locationInfo?.address ?? 'Location not available',
              imagePath: business.coverImage?.url ?? 'assets/images/post_image.png',
              isVerified: true,
              businessId: business.id ?? '',
              categoryId: widget.category.id,
              businessInfo: business, // Pass the business info from category coupons
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Listing image
            Stack(
              children: [
                SizedBox(
                  height: isTablet ? 360 : 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: business.coverImage?.url != null && business.coverImage!.url!.startsWith('http')
                        ? Image.network(
                            business.coverImage!.url!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/post_image.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/post_image.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                // Add a gradient overlay at the bottom for better text visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // Star icon with rating (green part)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF059E54), // Green background
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${(business.highestRating ?? 0).toDouble()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Number in white background
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: Text(
                            '${business.ratingCount ?? 0}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Listing details
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          business.companyInfo?.companyName ?? 'Business Name',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/check_icon.png',
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    business.locationInfo?.address ?? 'Location not available',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/images/utsav/banners/discount_offer.png',
                              fit: BoxFit.fill,
                              width: 210,
                              height: 33,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            bottom: 0,
                            left: 60,
                            right: 0,
                            child: SizedBox(
                              height: 32,
                              child: Text(
                                '${business.activeCouponCount ?? 0} Vouchers Available',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'DEC 31, 2025', // Default expiry - could be fetched from business coupons API
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Valid until',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CommonDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponsShimmer() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header with optional banner shimmer
          return Column(
            children: [
              if (_isBannerLoading) ...[
                const SizedBox(height: 10),
                Container(
                  height: 187,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFEEEEEE), indent: 16, endIndent: 16),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        // Coupon item shimmer
        return Container(
          margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 33,
                          width: 210,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 14,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 12,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const CommonDivider(),
            ],
          ),
        );
      },
    );
  }
}

class GridPatternPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double spacing;

  GridPatternPainter({
    required this.color,
    this.lineWidth = 1.0,
    this.spacing = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(GridPatternPainter oldDelegate) =>
      color != oldDelegate.color ||
      lineWidth != oldDelegate.lineWidth ||
      spacing != oldDelegate.spacing;
}
