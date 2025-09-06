import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../controller/all_temple_comtroller.dart';
import '../controller/city_controller.dart';
import '../screens/temple_detail_screen.dart';

class TemplesScreen extends StatefulWidget {
  const TemplesScreen({super.key});

  @override
  State<TemplesScreen> createState() => _TemplesScreenState();
}

class _TemplesScreenState extends State<TemplesScreen> {
  final HinduismCitiesController cityController = Get.put(HinduismCitiesController());
  final AllTempleController templeController = Get.put(AllTempleController());

  @override
  void initState() {
    super.initState();
    cityController.fetchCities();
    templeController.fetchTemples();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          const AppHeader(title: 'Temples', showShare: false),

          Obx(() {
            final bannerUrl = cityController.bannerImage['mobile_image']?.toString();
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: (bannerUrl != null && bannerUrl.isNotEmpty && bannerUrl != "null")
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bannerUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/spiritual/india_map.png');
                  },
                ),
              )
                  : Image.asset('assets/images/spiritual/india_map.png'),
            );
          }),


          SizedBox(
            height: isTablet ? 160 : 110,
            child: Obx(() {
              if (cityController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  _buildCategoryItem('All', 'assets/images/spiritual/all_temples.png', cityId: ''),
                  ...cityController.cities.map((city) => _buildCategoryItem(
                    city['name'].toString(),
                    city['image']?.toString() ?? 'assets/images/spiritual/default_city.png',
                    cityId: city['_id']?.toString() ?? '',
                  )).toList(),
                ],
              );
            }),
          ),

          Expanded(
            child: Obx(() {
              if (templeController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (templeController.temples.isEmpty && !templeController.isLoading.value) {
                return const Center(
                  child: Text('No temples found', style: AppTextStyles.medium14),
                );
              }

              return ListView.builder(
                itemCount: templeController.temples.length,
                itemBuilder: (context, index) {
                  final temple = templeController.temples[index];
                  return _buildTempleCard(context, temple);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleCard(BuildContext context, dynamic temple) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TempleDetailScreen(
              templeId: temple['_id']?.toString() ?? 'Temple',

            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    temple['image']?.toString() ?? '',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/spiritual/default_city.png',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  temple['name']?.toString() ?? 'Temple Name',
                  style: AppTextStyles.bold16,
                ),
                const SizedBox(height: 4),
                Text(
                 "${temple['location']['city']['name']?.toString() ?? 'city'}, ${ temple['location']['state']['name']?.toString() ?? 'State'}",
                  style: AppTextStyles.medium14,
                ),
                const SizedBox(height: 4),
                Text(
                  temple['about']?.toString() ?? '',
                  style: AppTextStyles.medium15,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CommonDivider(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, String imagePath, {String cityId = ''}) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isSelected = cityController.selectedCityId.value == cityId;

    return GestureDetector(
      onTap: () {
        cityController.selectedCityId.value = cityId; // 👈 Set selected city
        templeController.cityId = cityId;              // 👈 Pass to temple controller
        templeController.fetchTemples(isInitial: true); // 👈 Fetch temples of selected city
      },
      child: Container(
        width: isTablet ? 120 : 70,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isTablet ? 120 : 70,
              height: isTablet ? 120 : 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildSmartImage(imagePath),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.orange : Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildDefaultImage(),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultImage(),
      );
    }
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/images/spiritual/default_city.png',
      fit: BoxFit.cover,
    );
  }
}