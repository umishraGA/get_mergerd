import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/listings/views/VendorDetailsPage.dart';
import 'package:myapp/features/listings/widgets/RatingItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utsav/widgets/AppHeader.dart';
import 'filter_screen.dart';
import '../controller/api/listing_controller.dart';
import '../controller/api/listing_models.dart';

class VendorListPage extends StatefulWidget {
  final String categoryName;  // 👈 parameter to receive

  const VendorListPage({super.key, required this.categoryName});

  @override
  State<VendorListPage> createState() => _ClinicListPageState();
}

class _ClinicListPageState extends State<VendorListPage> {
  final ListingController _controller = ListingController();
  late Future<ListingResult> _future;

  @override
  void initState() {
    super.initState();
    _future = _controller.fetchListings(
      keyword: widget.categoryName,
      userLat: '28.610903',
      userLng: '77.114947',
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.categoryName;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ListingResult>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonLoading();
            }

            final result = snapshot.data;
            if (result == null) {
              return const Center(child: Text('No data'));
            }

            if (result.errorMessage != null) {
              return Center(child: Text('Error: ${result.errorMessage}'));
            }

            if (result.items.isEmpty) {
              return _buildNoDataFound(title: 'text', onRetry: () {  });
            }

            return Column(
              children: [
                AppHeader(
                  title: name,
                  subtitle: 'Mattyari,Lucknow - 226028',
                  showDropdown: true,
                  showShare: false,
                ),
                // Banner Carousel
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/utsav/banners/limited_time_offer.png',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Filter buttons row
                _buildFilterRow(),
                // Search results count
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 1, top: 0),
                  child: Text(
                    '${result.items.length} Results for your Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),

                // Clinic listings
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: result.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = result.items[index];
                      return _ClinicCard(item: item, isHighlighted: index == 0);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Column(
      children: [
        // AppHeader skeleton
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              SkeletonLoading(
                width: 40,
                height: 40,
                borderRadius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoading(
                      width: 150,
                      height: 20,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 6),
                    SkeletonLoading(
                      width: 200,
                      height: 16,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
              SkeletonLoading(
                width: 40,
                height: 40,
                borderRadius: 20,
              ),
            ],
          ),
        ),

        // Banner skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: SkeletonLoading(
            width: double.infinity,
            height: 200,
            borderRadius: 10,
          ),
        ),

        // Filter row skeleton
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              SkeletonLoading(
                width: 100,
                height: 40,
                borderRadius: 8,
              ),
              const SizedBox(width: 8),
              SkeletonLoading(
                width: 80,
                height: 40,
                borderRadius: 8,
              ),
              const SizedBox(width: 8),
              SkeletonLoading(
                width: 80,
                height: 40,
                borderRadius: 8,
              ),
            ],
          ),
        ),

        // Results count skeleton
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1, top: 0),
          child: SkeletonLoading(
            width: 200,
            height: 24,
            borderRadius: 4,
          ),
        ),

        // Clinic listings skeleton
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: 5, // Show 5 skeleton items
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildClinicCardSkeleton();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClinicCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Clinic info card skeleton
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoading(
                  width: 112,
                  height: 148,
                  borderRadius: 8,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoading(
                        width: 150,
                        height: 20,
                        borderRadius: 4,
                      ),
                      const SizedBox(height: 8),
                      SkeletonLoading(
                        width: 120,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const SizedBox(height: 12),
                      SkeletonLoading(
                        width: 100,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const SizedBox(height: 12),
                      SkeletonLoading(
                        width: 80,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const SizedBox(height: 12),
                      SkeletonLoading(
                        width: double.infinity,
                        height: 30,
                        borderRadius: 8,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Action buttons skeleton
          Row(
            children: [
              Expanded(
                child: SkeletonLoading(
                  height: 48,
                  borderRadius: 30, width: double.infinity,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SkeletonLoading(
                  height: 48,
                  borderRadius: 8, width: double.infinity,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SkeletonLoading(
                  height: 48,
                  borderRadius: 30, width: double.infinity,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const CommonDivider(),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          _buildFilterButton(
            'All Filters',
            icon: Icons.filter_list,
            isFirst: true,
          ),
          _buildFilterButton(
            'Sort By',
            icon: Icons.sort,
            showDropdown: true,
          ),
          _buildFilterButton(
            'Ratings',
            showDropdown: true,
          ),
        ],
      ),
    );
  }
}

Widget _buildFilterButton(
    String label, {
      IconData? icon,
      bool showDropdown = false,
      bool isFirst = false,
      VoidCallback? onTap,
    }) {
  return Container(
    margin: EdgeInsets.only(right: 8, left: isFirst ? 4 : 0),
    child: ElevatedButton(
      onPressed: onTap ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF8F9FA),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFDADCE0)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          if (showDropdown) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: Colors.black,
            ),
          ],
        ],
      ),
    ),
  );
}


class _ClinicCard extends StatelessWidget {
  final ListingItemModel item;
  final bool isHighlighted;
  const _ClinicCard({required this.item, this.isHighlighted = false});

  // 📞 Launch dialer
  Future<void> _launchDialer(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await  canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phone';
    }
  }

  // 🗺️ Launch Google Maps
  Future<void> _launchMaps(double lat, double lng) async {
    final Uri uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("id send to next page ${item.vendorId}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  VendorDetailsPage(id:item.vendorId.toString())),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFFFFDE7) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // --- Clinic info card ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: const Color(0xFFEFEFEF),
                      width: 112,
                      height: 148,
                      child: _buildClinicImage(item.logoUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                item.companyName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              color: Colors.green[600],
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _buildLocation(item),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF909090),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        const RatingItem(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Opens',
                              style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatHours(item),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(top: 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF371f66),
                                Color(0xFF371f66),
                                Color(0xFFFFFFFF)
                              ],
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '5+ offers on Utsav',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // --- Action buttons ---
            Row(
              children: [
                // 📞 Call
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final phone = (item.phoneNo ?? '').trim();
                      if (phone.isNotEmpty) {
                        _launchDialer(phone);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No phone available')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F9D58),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
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

                // ✉️ Enquiry
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement enquiry action
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

                // 🗺️ Direction
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final lat = item.latitude;
                      final lng = item.longitude;
                      if (lat != null && lng != null) {
                        _launchMaps(lat, lng);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No location available')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4976C2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
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
            const SizedBox(height: 10),
            const CommonDivider(),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _buildClinicImage(String? url) {
    if (url != null && url.isNotEmpty) {
      String optimizedUrl = url;
      if (url.endsWith('.avif') || url.endsWith('.webp')) {
        optimizedUrl = url.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
      }
      return CachedNetworkImage(
        imageUrl: optimizedUrl,
        fit: BoxFit.cover,
        placeholder: (context, _) =>
        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, _, __) => const Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey,
        ),
      );
    }
    return const Icon(Icons.image, size: 40, color: Colors.grey);
  }

  String _buildLocation(ListingItemModel item) {
    final distance = item.distanceKm != null
        ? '${item.distanceKm!.toStringAsFixed(1)} km'
        : null;
    final address = (item.address ?? '').trim();
    if (address.isEmpty && distance == null) return 'Unknown location';
    if (address.isEmpty) return distance!;
    return distance == null ? address : '$address, $distance';
  }

  String _formatHours(ListingItemModel item) {
    if (item.businessHours.isEmpty) return 'Hours not available';
    final today = DateTime.now().weekday; // 1=Mon..7=Sun
    final mapping = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    final todayName = mapping[today];
    final match = item.businessHours.firstWhere(
          (h) => h.day == todayName,
      orElse: () => item.businessHours.first,
    );
    if (match.isClosed) return 'Closed ${match.day}';
    if (match.isOpen24Hours) return 'Open 24 hours';
    return 'Closes ${match.closeTime}';
  }
}

Widget _buildClinicImage(String? url) {
  if (url != null && url.isNotEmpty) {
    String optimizedUrl = url;

    // Convert .avif or .webp → .jpg fallback
    if (url.endsWith('.avif') || url.endsWith('.webp')) {
      optimizedUrl = url.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
    }

    return CachedNetworkImage(
      imageUrl: optimizedUrl,
      fit: BoxFit.cover,
      placeholder: (context, _) => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, _, __) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }

  return const Icon(Icons.image, size: 40, color: Colors.grey);
}

String _buildLocation(ListingItemModel item) {
  final distance = item.distanceKm != null
      ? '${item.distanceKm!.toStringAsFixed(1)} km'
      : null;
  final address = (item.address ?? '').trim();
  if (address.isEmpty && distance == null) return 'Unknown location';
  if (address.isEmpty) return distance!;
  return distance == null ? address : '$address, $distance';
}

Widget _buildNoDataFound({
  String title = 'No Data Found',
  VoidCallback? onRetry,
  String retryText = 'Try Again',
  List<Widget>? additionalActions,
}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (onRetry != null)
          ElevatedButton(
            onPressed: onRetry,
            child: Text(retryText),
          ),
        if (additionalActions != null) ...[
          const SizedBox(height: 8),
          ...additionalActions,
        ],
      ],
    ),
  );
}


String _formatHours(ListingItemModel item) {
  if (item.businessHours.isEmpty) return 'Hours not available';
  final today = DateTime.now().weekday; // 1=Mon..7=Sun
  final mapping = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
  };
  final todayName = mapping[today];
  final match = item.businessHours.firstWhere(
        (h) => h.day == todayName,
    orElse: () => item.businessHours.first,
  );
  if (match.isClosed) return 'Closed ${match.day}';
  if (match.isOpen24Hours) return 'Open 24 hours';
  return 'Closes ${match.closeTime}';
}

// Skeleton Loading Widget
class SkeletonLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  _SkeletonLoadingState createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _animation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}