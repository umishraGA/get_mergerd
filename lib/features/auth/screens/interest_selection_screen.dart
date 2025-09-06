import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/get_interest_controller.dart';
import '../controller/post_selected_interested_controller.dart';
import 'success_screen.dart';

class Interest {
  final String id;
  final String name;
  final String imageUrl;
  final String followerCount;
  RxBool isSelected;

  Interest({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.followerCount,
    bool isSelected = false,
  }) : isSelected = isSelected.obs;

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
      followerCount: json['followers']?.toString() ?? '0',
    );
  }
}

class InterestSelectionScreen extends StatelessWidget {
  final GetInterestController controller = Get.put(GetInterestController());
  final AddInterestController addInterestController =
  Get.put(AddInterestController());

  InterestSelectionScreen({super.key});

  int getSelectedCount(List<Interest> interests) {
    return interests.where((i) => i.isSelected.value).length;
  }

  bool canContinue(List<Interest> interests) {
    return getSelectedCount(interests) >= 3;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1024;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back,
                  color: Color(0xFF426DB3), size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: Obx(() {
          final count = getSelectedCount(controller.interestList);
          return Column(
            children: [
              const Text(
                'Tell Us What You Love',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selected: $count of 3 required',
                style: TextStyle(
                  color: count >= 3
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight:
                  count >= 3 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Choose at least 3 interests, and we\'ll curate the best content for your posts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: isTablet ? 16 : 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;

                  // Responsive columns
                  int crossAxisCount = 2;
                  if (width > 1200) {
                    crossAxisCount = 5;
                  } else if (width > 800) {
                    crossAxisCount = 4;
                  } else if (width > 500) {
                    crossAxisCount = 3;
                  }

                  double childAspectRatio =
                  isTablet ? 0.9 : isDesktop ? 1.0 : 0.75;

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: controller.interestList.length,
                    itemBuilder: (context, index) {
                      return Obx(() =>
                          _buildInterestItem(controller.interestList[index], size));
                    },
                  );
                },
              );
            }),
          ),
          Obx(() => _buildBottomBar(controller.interestList, context, size)),
        ],
      ),
    );
  }

  Widget _buildInterestItem(Interest interest, Size size) {
    final isSelected = interest.isSelected.value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF6FE) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.1 : 0.05),
            blurRadius: isSelected ? 10 : 5,
            offset: const Offset(0, 2),
            spreadRadius: isSelected ? 1 : 0,
          ),
        ],
        border: Border.all(
          color: isSelected ? const Color(0xFF426DB3) : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => interest.isSelected.toggle(),
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0x20426DB3),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: size.height * 0.14, // responsive image height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: interest.imageUrl.startsWith("http")
                            ? CachedNetworkImageProvider(interest.imageUrl)
                            : AssetImage(interest.imageUrl)
                        as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: double.infinity,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0x66426DB3),
                      ),
                      child: const Icon(Icons.check_circle,
                          color: Colors.white, size: 40),
                    ),
                ],
              ),
              SizedBox(height: size.height * 0.015),
              Text(
                interest.name,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w600,
                  color:
                  isSelected ? const Color(0xFF426DB3) : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.people,
                      size: size.width * 0.03,
                      color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    interest.followerCount,
                    style: TextStyle(
                        fontSize: size.width * 0.03,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(List<Interest> list, BuildContext context, Size size) {
    final count = getSelectedCount(list);
    final canProceed = canContinue(list);
    return Container(
      padding: EdgeInsets.fromLTRB(
          size.width * 0.05, 16, size.width * 0.05, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count >= 3
                ? 'Great! You\'ve selected $count interests'
                : 'Please select ${3 - count} more interest${3 - count == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: size.width * 0.035,
              color: count >= 3
                  ? const Color(0xFF4CAF50)
                  : Colors.grey.shade600,
              fontWeight:
              count >= 3 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.07,
            child: ElevatedButton(
              onPressed: canProceed
                  ? () {
                final selectedIds = controller.interestList
                    .where((i) => i.isSelected.value)
                    .map((i) => i.id)
                    .toList();

                addInterestController.submitInterests(selectedIds);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuccessScreen(),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF426DB3),
                disabledBackgroundColor:
                const Color(0xFF426DB3).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                canProceed
                    ? 'Continue'
                    : 'Select at least 3 interests',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
