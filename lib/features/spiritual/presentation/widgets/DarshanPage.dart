import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/screens/live_darshan_screen.dart';
import 'package:myapp/features/spiritual/presentation/widgets/DarshanCard.dart';

import '../controller/temple_detail_controller.dart';
import '../screens/live_darshan_player_screen.dart';

class DarshanPage extends StatelessWidget {
  final String templeId;

  DarshanPage({super.key, required this.templeId});

  final TempleDetailController templeDetailController = Get.put(TempleDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (templeDetailController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (templeDetailController.liveDarshan.isEmpty) {
        return const Center(
          child: Text(
            'No Data Found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        itemCount: templeDetailController.liveDarshan.length,
        separatorBuilder: (context, index) => const Divider(
          color: Color(0xFFEEEEEE),
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final darshan = templeDetailController.liveDarshan[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveDarshanPlayerScreen(
                      id: darshan['_id']?.toString() ?? '',
                    ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aarti image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.network(
                          darshan['mobile_image']?.toString() ?? '',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
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
                            border: Border.all(
                              color: const Color(0xFFE57373),
                              width: 1,
                            ),
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
                          darshan['title']?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          darshan['temple'].toString() ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF909090),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {},
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
        },
      );
    });
  }
}