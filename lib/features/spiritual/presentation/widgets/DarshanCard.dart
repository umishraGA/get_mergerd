import 'package:flutter/material.dart';

class DarshanCard extends StatelessWidget {
  final String image;
  final String title;
  final String temple;
  final VoidCallback onTap;
  const DarshanCard(
      {super.key,
      required this.image,
      required this.title,
      required this.temple,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _build(
      context: context,
      image: image,
      title: title,
      temple: temple,
    );
  }

  Widget _build({
    required BuildContext context,
    required String image,
    required String title,
    required String temple,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aarti image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Image.asset(
                    image,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  // Live badge overlay
                ],
              ),
            ),
            // Content
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8DCDC),
                      border:
                          Border.all(color: const Color(0xFFE57373), width: 1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Color(0xFFE53935),
                          size: 8,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'LIVE DARSHAN',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    temple,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF909090),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDB92E),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(120, 36),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Darshan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
