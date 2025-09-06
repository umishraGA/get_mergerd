import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Islam_controller/allah_name_detail_controller.dart';

class AsmaNameDetailScreen extends StatefulWidget {
  final String id;

  const AsmaNameDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<AsmaNameDetailScreen> createState() => _AsmaNameDetailScreenState();
}

class _AsmaNameDetailScreenState extends State<AsmaNameDetailScreen> {
  final AllahNameDetailController controller =
      Get.put(AllahNameDetailController());

  @override
  void initState() {
    super.initState();
    controller.fetchNameDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2639),
        elevation: 0,
        title: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }
          return Text(
            controller.englishName.toUpperCase(),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "Amiri"),
          );
        }),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage != null) {
          return Center(child: Text(controller.errorMessage!));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bismillah Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 32,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              // Name Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: Center(
                  child: Text(
                    controller.englishName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // Arabic Name
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: Center(
                  child: Text(
                    controller.arabicName,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 30,
                      height: 1.2,
                    ),
                  ),
                ),
              ),

              const Divider(height: 1),

              // Number and English Meaning
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: Text(
                  '${controller.sortingNo}. ${controller.englishName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const Divider(height: 1),

              // Meaning Section
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meaning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.meaning,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Benefits',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.benefits,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
