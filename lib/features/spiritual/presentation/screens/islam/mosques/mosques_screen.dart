import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MosquesScreen extends StatefulWidget {
  const MosquesScreen({super.key});

  @override
  State<MosquesScreen> createState() => _MosquesScreenState();
}

class _MosquesScreenState extends State<MosquesScreen> {
  final List<Map<String, dynamic>> _mosques = [
    {
      'name': 'Masjid-e-Gulzar',
      'location': 'Gulzar Colony (Chinhat)',
      'distance': 0.238,
    },
    {
      'name': 'Hamza Al Tahid',
      'location': 'India',
      'distance': 3.1,
    },
    {
      'name': 'Mosque @ Munshipulia',
      'location': 'Munshipulia (Indiranagar)',
      'distance': 3.8,
    },
    {
      'name': 'Asifi Masjid',
      'location': 'Mashakganj (226018)',
      'distance': 4.7,
    },
    {
      'name': 'Mohammadi Mosque',
      'location': 'kursi ry',
      'distance': 7.6,
    },
    {
      'name': 'Noorani Masjid',
      'location': 'Adil Nagar',
      'distance': 7.9,
    },
    {
      'name': 'Masjid Rahmaniya',
      'location': 'Aminabad',
      'distance': 10.7,
    },
    {
      'name': 'Masjeed Taj Muhammad',
      'location': 'Aminabad',
      'distance': 10.8,
    },
    {
      'name': 'Khamman Peer Mazaar',
      'location': 'Lucknow',
      'distance': 11.0,
    },
    {
      'name': 'zama masjid,lucknow',
      'location': 'India',
      'distance': 11.1,
    },
    {
      'name': 'Tilewali Masjid',
      'location': 'Lucknow 226003',
      'distance': 11.6,
    },
    {
      'name': 'Badi Masjeed',
      'location': 'Badi Masjeed (Sarvodaya Nagar)',
      'distance': 11.6,
    },
    {
      'name': 'Ek Minara Masjid',
      'location': 'Lucknow 226007',
      'distance': 12.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Mosques',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.map,
              color: Colors.green,
              size: 24,
            ),
            onPressed: () {
              // Show map view
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _mosques.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final mosque = _mosques[index];
          return MosqueListItem(
            name: mosque['name'] as String,
            location: mosque['location'] as String,
            distance: mosque['distance'] as double,
          );
        },
      ),
    );
  }
}

class MosqueListItem extends StatelessWidget {
  final String name;
  final String location;
  final double distance;

  const MosqueListItem({
    super.key,
    required this.name,
    required this.location,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    String distanceText;
    if (distance < 1) {
      distanceText = '${(distance * 1000).toInt()} m';
    } else {
      distanceText = '${distance.toStringAsFixed(1)} km';
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: SvgPicture.asset(
        'assets/images/spiritual/islam/mosque_icon.svg',
        width: 32,
        height: 32,
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        location,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
      ),
      trailing: Text(
        distanceText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.green,
        ),
      ),
      onTap: () {
        // Navigate to mosque detail or open in maps
      },
    );
  }
}
