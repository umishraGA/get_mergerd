import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Islam_controller/dua_detail_controller.dart';
import 'dua_detail_screen.dart';

class DuaCategoryScreen extends StatefulWidget {
  final String id;
  final String image; // image URL or asset path
  final String title; // added title if needed

  const DuaCategoryScreen({
    super.key,
    required this.id,
    required this.image,
    required this.title,
  });

  @override
  State<DuaCategoryScreen> createState() => _DuaCategoryScreenState();
}

class _DuaCategoryScreenState extends State<DuaCategoryScreen> {
  final DuaDetailController duaDetailController =
      Get.put(DuaDetailController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    duaDetailController.fetchDuasByCategory(widget.id);
  }

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
      body: Column(
        children: [
          // 🖼️ Banner image with gradient and title
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.image.startsWith('http')
                    ? NetworkImage(widget.image)
                    : AssetImage(widget.image) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  bottom: 24,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (duaDetailController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (duaDetailController.duaList.isEmpty) {
                return const Center(child: Text('No Duas found.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: duaDetailController.duaList.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  indent: 10,
                  endIndent: 10,
                ),
                itemBuilder: (context, index) {
                  final dua = duaDetailController.duaList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DuaDetailScreen(dua: dua),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            child: Text(
                              dua.sortingNo,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              dua.titleEnglish,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),


        ],
      ),
    );
  }
}
