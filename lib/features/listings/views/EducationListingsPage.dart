import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/listings/views/AyurvedicDoctorsPage.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';


class EducationListingsPage extends StatefulWidget {
  final String id;

  const EducationListingsPage({
    super.key,
    required this.id,
  });
  @override
  State<EducationListingsPage> createState() => _EducationListingsPageState();
}

class _EducationListingsPageState extends State<EducationListingsPage> {


  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            const AppHeader(
              title: 'Education',
              showDivider: true,
              showShare: false,
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner Carousel
                    Bannercorousal(
                      height: isTablet ? 280 : 160,
                    ),
                    Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 5,
                        separatorBuilder: (context, index) => const CommonDivider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                            // leading: Icon(
                            //   category['icon'] as IconData,
                            //   color: Colors.grey[700],
                            // ),
                            title: const Text("Test mode",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AyurvedicDoctorsPage(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
