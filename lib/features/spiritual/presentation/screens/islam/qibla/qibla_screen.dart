import 'dart:math';

import 'package:flutter/material.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final String _locationName = "Lucknow, India";
  final double _qiblaAngle = 271; // Example fixed angle for design purposes
  int _selectedCompassIndex = 0;

  // List of compass designs
  final List<String> _compassDesigns = [
    'classic', // Default classic design
    'modern',
    'elegant',
    'digital',
    'dark',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Qibla',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Location info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 28,
                  color: Colors.black54,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your location',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _locationName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Compass
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Compass background
                  Image.asset(
                    'assets/images/spiritual/islam/compass_new.png',
                    width: 500,
                    height: 500,
                    fit: BoxFit.contain,
                  ),

                  // Qibla indicator (red needle)
                  Transform.rotate(
                    angle: _qiblaAngle * (pi / 180),
                    child: Container(
                      width: 4,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.red, Colors.transparent],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Kaaba icon in center
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Direction info
          Text(
            'Qibla angle $_qiblaAngle°',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Mosque skyline
          // Container(
          //   height: 100,
          //   width: double.infinity,
          //   margin: const EdgeInsets.only(top: 16),
          //   child: Image.asset(
          //     'assets/images/mosque_skyline.png',
          //     fit: BoxFit.contain,
          //     color: Colors.blue.withAlpha(40),
          //   ),
          // ),

          // Compass style selector
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Choose Compass Style",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4976C2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCompassStyleOption(0, "Classic", Colors.brown),
                    _buildCompassStyleOption(1, "Modern", Colors.indigo),
                    _buildCompassStyleOption(2, "Gold", Colors.amber),
                    _buildCompassStyleOption(3, "Dark", Colors.black),
                    _buildCompassStyleOption(
                        4, "Blue", const Color(0xFF4976C2)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCompassStyleOption(int index, String label, Color color) {
    final bool isSelected = _selectedCompassIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCompassIndex = index;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
