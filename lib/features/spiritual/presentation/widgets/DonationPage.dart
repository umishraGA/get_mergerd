import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';

import '../controller/temple_detail_controller.dart';

class DonationPage extends StatelessWidget {
  final String templeId;

  DonationPage({super.key, required this.templeId});

  final TempleDetailController templeDetailController = Get.put(TempleDetailController());

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Obx(() {
      if (templeDetailController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (templeDetailController.donations.isEmpty) {
        return const Center(child: Text('No donation options available'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: templeDetailController.donations.length,
        itemBuilder: (context, index) {
          final donation = templeDetailController.donations[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Temple image at the top
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: donation["image"] != null
                    ? Image.network(
                  donation["image"].toString(),
                  width: double.infinity,
                  height: isTablet ? 360 : 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/spiritual/temple_donation.jpg',
                    width: double.infinity,
                    height: isTablet ? 360 : 200,
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  'assets/images/spiritual/temple_donation.jpg',
                  width: double.infinity,
                  height: isTablet ? 360 : 200,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              // Donation options text
              Html(
                data: donation["description"].toString(),
                style: {
                  "body": Style(
                    fontSize: FontSize(15.0),
                    fontFamily: AppTextStyles.medium15.fontFamily,
                    fontWeight: AppTextStyles.medium15.fontWeight,
                    color: AppTextStyles.medium15.color,
                  ),
                },
              ),

              const SizedBox(height: 30),

              // Donate Now button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE05757),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  donation["button_text"].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Add divider if not the last item
              if (index != templeDetailController.donations.length - 1)
                _buildDivider(),
            ],
          );
        },
      );
    });
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const CommonDivider();
  }
}