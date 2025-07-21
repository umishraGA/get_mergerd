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
  final AddInterestController addInterestController = Get.put(AddInterestController());

  InterestSelectionScreen({super.key});

  int getSelectedCount(List<Interest> interests) {
    return interests.where((i) => i.isSelected.value).length;
  }

  bool canContinue(List<Interest> interests) {
    return getSelectedCount(interests) >= 3;
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Icon(Icons.arrow_back, color: Color(0xFF426DB3), size: 20),
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
                  color: count >= 3 ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: count >= 3 ? FontWeight.w600 : FontWeight.normal,
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
              'Choose at least 3 interests, and we\'ll curate the best content for your feed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
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

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: controller.interestList.length,
                itemBuilder: (context, index) {
                  return Obx(() => _buildInterestItem(controller.interestList[index]));
                },
              );
            }),
          ),
          Obx(() => _buildBottomBar(controller.interestList, context)),
        ],
      ),
    );
  }

  Widget _buildInterestItem(Interest interest) {
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: interest.imageUrl.startsWith("http")
                            ? NetworkImage(interest.imageUrl)
                            : AssetImage(interest.imageUrl) as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0x66426DB3),
                      ),
                      child: const Icon(Icons.check_circle, color: Colors.white, size: 40),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                interest.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF426DB3) : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.people, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    interest.followerCount,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(List<Interest> list, BuildContext context) {
    final count = getSelectedCount(list);
    final canProceed = canContinue(list);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              fontSize: 14,
              color: count >= 3 ? const Color(0xFF4CAF50) : Colors.grey.shade600,
              fontWeight: count >= 3 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: canProceed
                  ? () {
                final selectedIds = controller.interestList
                    .where((i) => i.isSelected.value)
                    .map((i) => i.id)
                    .toList();

                print("Selected Interest IDs: $selectedIds");
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
                disabledBackgroundColor: const Color(0xFF426DB3).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                canProceed ? 'Continue' : 'Select at least 3 interests',
                style: const TextStyle(
                  fontSize: 16,
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
