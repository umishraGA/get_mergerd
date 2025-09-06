
import 'package:flutter/material.dart';

import '../../widgets/RatingItem.dart';
import 'listing_controller.dart';
import 'listing_models.dart';

class ClinicListPage extends StatefulWidget {
  const ClinicListPage({super.key});

  @override
  State<ClinicListPage> createState() => _ClinicListPageState();
}

class _ClinicListPageState extends State<ClinicListPage> {
  final ListingController _controller = ListingController();
  late Future<ListingResult> _future;

  @override
  void initState() {
    super.initState();
    _future = _controller.fetchListings(
      keyword: 'Open Schools',
      userLat: '28.610903',
      userLng: '77.114947',
      authToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6Ijc0NjA4Mzc3MjUiLCJfaWQiOiI2OGFkNmIxODkzNzhhOGVlMDNmNDllNWYiLCJpYXQiOjE3NTYyODY3OTQsImV4cCI6MTc1ODg3ODc5NH0.C3_X1vda9ae1bc2fxvjCTP37bwDzO_vnWeJakLeHfE0',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinics')),
      body: FutureBuilder<ListingResult>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final result = snapshot.data;
          if (result == null) {
            return const Center(child: Text('No data'));
          }
          if (result.errorMessage != null) {
            return Center(child: Text('Error: ${result.errorMessage}'));
          }
          if (result.items.isEmpty) {
            return const Center(child: Text('No clinics found'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: result.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = result.items[index];
              return _ClinicCard(item: item, isHighlighted: index == 0);
            },
          );
        },
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final ListingItemModel item;
  final bool isHighlighted;
  const _ClinicCard({required this.item, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _backgroundForType(item.type, isHighlighted);
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: bgColor,
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
                    height: 150,
                    child: item.logoUrl != null && item.logoUrl!.isNotEmpty
                        ? Image.network(
                            item.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            (item.companyName.isEmpty ? 'Unnamed' : item.companyName)
                                .split(' ')
                                .take(20)
                                .join(' '),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(width: 4),

                          const Icon(Icons.verified, color: Colors.green, size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _buildLocation(item),
                        style: const TextStyle(fontSize: 14, color: Color(0xFF909090)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const RatingItem(),
                      const SizedBox(height: 8),


                      Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.green[600], size: 14),
                          const SizedBox(width: 6),
                          Text(
                            _formatHours(item),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final phone = (item.phoneNo ?? '').trim();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(phone.isEmpty ? 'No phone available' : 'Phone: $phone')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryForType(item.type),
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
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentForType(item.type),
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
                  onPressed: () {
                    final lat = item.latitude;
                    final lng = item.longitude;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(lat == null || lng == null ? 'No location' : 'Lat: $lat, Lng: $lng')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondaryForType(item.type),
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
        ],
      ),
    );
  }

  String _buildLocation(ListingItemModel item) {
    final distance = item.distanceKm != null ? '${item.distanceKm!.toStringAsFixed(1)} km' : null;
    final address = (item.address ?? '').trim();
    if (address.isEmpty && distance == null) return 'Unknown location';
    if (address.isEmpty) return distance!;
    return distance == null ? address : '$address · $distance';
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
    if (match.isClosed) return '${match.day}: Closed';
    if (match.isOpen24Hours) return '${match.day}: Open 24 hours';
    return '${match.day}: ${match.openTime} - ${match.closeTime}';
  }

  Color _backgroundForType(String type, bool highlighted) {
    switch (type) {
      case 'paid':
        return const Color(0xFFFFF3E0); // light orange
      case 'fixed':
        return const Color(0xFFE3F2FD); // light blue
      case 'free':
      default:
        return highlighted ? const Color(0xFFFFFDE7) : Colors.white; // light yellow or white
    }
  }

  Color _primaryForType(String type) {
    switch (type) {
      case 'paid':
        return const Color(0xFFF57C00); // deep orange
      case 'fixed':
        return const Color(0xFF1976D2); // blue
      case 'free':
      default:
        return const Color(0xFF0F9D58); // green
    }
  }

  Color _secondaryForType(String type) {
    switch (type) {
      case 'paid':
        return const Color(0xFF8E24AA); // purple
      case 'fixed':
        return const Color(0xFF1565C0); // darker blue
      case 'free':
      default:
        return const Color(0xFF4976C2); // default blue
    }
  }

  Color _accentForType(String type) {
    switch (type) {
      case 'paid':
        return const Color(0xFFFFD54F); // amber
      case 'fixed':
        return const Color(0xFF90CAF9); // light blue
      case 'free':
      default:
        return const Color(0xFFFBC02D); // yellow
    }
  }
}


