import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';

import '../controller/temple_detail_controller.dart';

class AboutUs extends StatelessWidget {
  final String templeId;

  const AboutUs({
    super.key,
    required this.templeId,
  });

  @override
  Widget build(BuildContext context) {
    final TempleDetailController controller = Get.put(TempleDetailController());
    controller.fetchTempleDetails(templeId);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About text
            Text(
              controller.about.isNotEmpty
                  ? controller.about
                  : 'No description available',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),
            const CommonDivider(),
            const SizedBox(height: 10),

            // History section
            const Text(
              'History of Temple',
              style: AppTextStyles.bold18,
            ),

            const SizedBox(height: 10),

            Text(
              controller.additionalInfo.isNotEmpty
                  ? controller.additionalInfo.first['content']?.toString() ?? 'No history available'
                  : 'No history available',
              style: AppTextStyles.medium15,
            ),

            const SizedBox(height: 10),
            const CommonDivider(),
            const SizedBox(height: 10),

            // Darshan time section
            const Text(
              'Darshan Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...controller.darshanTimings.map((timing) => Column(
              children: [
                _buildTimeSection(
                    timing['title']?.toString() ?? 'Darshan',
                    '${timing['start']} - ${timing['end']}'
                ),
                const SizedBox(height: 8),
              ],
            )).toList(),

            const SizedBox(height: 10),
            const CommonDivider(),
            const SizedBox(height: 10),

            // Aarti time section
            const Text(
              'Aarti Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...controller.aartiTimings.map((timing) => Column(
              children: [
                _buildTimeSection(
                    timing['title']?.toString() ?? 'Aarti',
                    '${timing['start']} - ${timing['end']}'
                ),
                const SizedBox(height: 8),
              ],
            )).toList(),

            const SizedBox(height: 10),
            const CommonDivider(),
            const SizedBox(height: 10),

            // Address section
            const Text(
              'Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '${controller.city}, ${controller.state}, ${controller.country}',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),
            const CommonDivider(),
            const SizedBox(height: 10),

            // Google Map section
            const Text(
              'Google Map',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                // Open map with temple location
                final location = controller.location;
                if (location['google_map_url'] != null) {
                  // Launch URL here
                }
              },
              icon: const Icon(Icons.directions),
              label: const Text('Get Direction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6BD6),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const CommonDivider(),
            const SizedBox(height: 10),

            // Social Media section
            const Text(
              'Social Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                if (controller.socialLinks['youtube'] != null)
                  _buildSocialIconWithLink(
                    "assets/images/spiritual/youtube_logo.png",
                    controller.socialLinks['youtube'].toString(),
                  ),
                const SizedBox(width: 16),
                if (controller.socialLinks['instagram'] != null)
                  _buildSocialIconWithLink(
                    "assets/images/spiritual/insta_logo.png",
                    controller.socialLinks['instagram'].toString(),
                  ),
                const SizedBox(width: 16),
                if (controller.socialLinks['facebook'] != null)
                  _buildSocialIconWithLink(
                    "assets/images/spiritual/facebook_logo.png",
                    controller.socialLinks['facebook'].toString(),
                  ),
              ],
            ),

            const SizedBox(height: 10),
            const CommonDivider(),
            const SizedBox(height: 10),

            // Contact section
            const Text(
              'Contact',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              controller.contactNumber,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  Widget _buildTimeSection(String title, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIconWithLink(String image, String url) {
    return GestureDetector(
      onTap: () {
        // Launch URL here
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(
          image,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}