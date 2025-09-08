import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';

import '../../../utils/locationUtils/LocationUtils.dart';
import '../models/UtsavCategory.dart';
import '../models/CouponCategoryModels.dart';
import '../UtsavViewModel.dart';
import '../UtsavRepository.dart';
import '../../../utils/dio/api_service.dart';
import '../utils/UtsavSetup.dart';
import '../widgets/UtsavCategoryCard.dart';
import '../models/HomeBannerModels.dart';
import 'UtsavCategoryPage.dart';

class UtsavPage extends StatefulWidget {
  const UtsavPage({super.key});

  @override
  State<UtsavPage> createState() => _UtsavPageState();
}

class _UtsavPageState extends State<UtsavPage> {
  // Controller for banner page view
  late final PageController _bannerController;
  // Flag to track if assets were checked
  bool _assetsChecked = false;
  // ViewModel instance
  late final UtsavViewModel _viewModel;
  // Categories from API
  List<UtsavCategory> categories = [];
  // Home banners from API
  List<HomeBanner> _homeBanners = [];
  // Loading state
  bool _isLoading = true;
  bool _isBannerLoading = true;
  // Error message
  String? _errorMessage;
  String? _bannerErrorMessage;

  // Sample offer banners - you'll replace the image paths later

  @override
  void initState() {
    super.initState();
    // Initialize banner controller with viewport fraction
    _bannerController = PageController(
      viewportFraction:
          0.8, // Smaller value to show more of adjacent banners on both sides
      initialPage: 1000, // Start at a large number for infinite effect
    );
    // Initialize ViewModel
    _viewModel = UtsavViewModel(
        repository: UtsavRepository(apiService: ApiService()));
    // Run asset check after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUtsavAssets();
      _loadCategories();
      _loadHomeBanners();
    });
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final response = await _viewModel.getCouponCategories();
      
      setState(() {
        categories = response.data?.map((category) => UtsavCategory(
          id: category.id ?? '',
          name: category.categoryname ?? 'Unknown Category',
          imagePath: category.mobthumbnail ?? 'assets/images/utsav/categories/default.png',
        )).toList() ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadHomeBanners() async {
    try {
      setState(() {
        _isBannerLoading = true;
        _bannerErrorMessage = null;
      });

      var coordinates = await LocationUtils.getUserCoordinates();
      var latitude = coordinates[0];
      var longitude = coordinates[1];

      final response = await _viewModel.getHomeBanners(
        latitude: latitude.toString(),
        longitude: longitude.toString(),
      );
      
      final activeBanners = response.data
          .where((banner) => banner.status == 'ACTIVE')
          .toList();
      
      setState(() {
        _homeBanners = activeBanners;
        _isBannerLoading = false;
      });
    } catch (e) {
      setState(() {
        _bannerErrorMessage = 'Failed to load banners: ${e.toString()}';
        _isBannerLoading = false;
      });
    }
  }

  void _checkUtsavAssets() {
  if (!_assetsChecked) {
      UtsavSetup.ensureUtsavSetup();
      setState(() {
        _assetsChecked = true;
      });
    }
  }

  List<String>? _getHomeBannerUrls(bool isTablet) {
    if (_homeBanners.isEmpty) {
      return null; // This will use default banners
    }
    
    return _homeBanners
        .map((banner) => banner.getBannerUrl(isMobile: !isTablet))
        .toList();
  }

  void _onBannerTap(int index) {
    if (_homeBanners.isEmpty || index >= _homeBanners.length) {
      return;
    }

    final banner = _homeBanners[index];
    
    // Create a temporary category for the business to navigate to UtsavCategoryPage
    // The category page will use the business ID to fetch business-specific coupons
    final businessCategory = UtsavCategory(
      id: banner.businessId,
      name: '${banner.address} - Special Offers',
      imagePath: banner.getBannerUrl(isMobile: true), // Use banner as category image
    );

    // Navigate to category page - it will handle business coupons
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UtsavCategoryPage(
          category: businessCategory,
        ),
      ),
    );
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

  void _handleNotificationTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification clicked'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: null,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            _loadCategories(),
            _loadHomeBanners(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom header with search
              TopAppBarCustom(
                color: const Color(0xFFFFCA28),
                textColor: Colors.black,
                subTitleColor: Colors.black,
                onSearchSubmitted: _handleSearch,
              ),

              // Home Banner carousel - only show if banners are available
              _isBannerLoading
                  ? _buildBannerShimmer(isTablet)
                  : _homeBanners.isNotEmpty
                      ? Bannercorousal(
                          height: isTablet ? 280 : 160,
                          imagePaths: _getHomeBannerUrls(isTablet),
                          onBannerTap: _onBannerTap,
                        )
                      : const SizedBox.shrink(), // Hide banner section when no banners available

              // Popular categories
              _buildPopularCategories(),

              // Categories grid
              _buildCategoriesGrid(),

              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCategories() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      child: Text(
        'All Utsav Categories',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: _isLoading 
        ? _buildCategoriesShimmer()
        : _errorMessage != null
          ? Center(
              child: Padding(
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
                      onPressed: _loadCategories,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return UtsavCategoryCard(
                  category: categories[index],
                  onTap: () {
                    // Navigate to category detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UtsavCategoryPage(
                          category: categories[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildBannerShimmer(bool isTablet) {
    return Container(
      height: isTablet ? 280 : 160,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildCategoriesShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6, // Show 6 shimmer placeholders
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}
