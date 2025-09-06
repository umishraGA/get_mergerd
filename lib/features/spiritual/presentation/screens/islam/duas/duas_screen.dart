import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Islam_controller/dua_controller.dart';
import 'dua_category_screen.dart';
import 'dua_detail_screen.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  final DuaController duaController = Get.put(DuaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Duas',
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
        body: Obx(() {
          if (duaController.isLoading.value && duaController.duaList.isEmpty) {
            // Initial loading
            return const Center(child: CircularProgressIndicator());
          } else if (duaController.duaList.isEmpty) {
            // No data
            return const Center(child: Text('No Duas available'));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await duaController.refreshDuas();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: duaController.duaList.length,
                itemBuilder: (context, index) {
                  final dua = duaController.duaList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DuaCategoryScreen(
                            id: dua['_id']?.toString() ?? 'No name',
                            image: dua['mobile_image']?.toString() ?? 'No name',
                            title: dua['english_category_name']?.toString() ?? 'No name',
                          ),
                        ),
                      );
                    },
                    child: DuasCategoryCard(
                      title:
                          dua['english_category_name']?.toString() ?? 'No name',
                      imagePath: dua['mobile_image']?.toString() ?? 'No name',
                      count: dua['sorting_no']?.toString() ?? 'No name',
                    ),
                  );
                },
              ),
            );
          }
        }));
  }
}

class DuasCategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String count;

  const DuasCategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),

            // Title
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Count circle
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Play button for Travel (last item)
            if (title == 'Travel')
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
