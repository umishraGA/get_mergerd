import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/spiritual/presentation/screens/live_darshan_player_screen.dart';
import 'package:myapp/features/spiritual/presentation/widgets/DarshanCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../controller/live_darshan_controller.dart';

class LiveDarshanScreen extends StatefulWidget {
  const LiveDarshanScreen({super.key});

  @override
  State<LiveDarshanScreen> createState() => _LiveDarshanScreenState();
}

class _LiveDarshanScreenState extends State<LiveDarshanScreen> {
  final LiveDarshanController liveDarshanController = Get.put(LiveDarshanController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          const AppHeader(title: 'Live Darshan'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              itemCount: liveDarshanController.darshanList.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFEEEEEE),
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final darshan = liveDarshanController.darshanList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Obx((){
                    if (liveDarshanController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (liveDarshanController.darshanList.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Data Found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: (){
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
                                ),
                                // Live badge overlay
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
                                    border:
                                    Border.all(color: const Color(0xFFE57373), width: 1),
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
                                  darshan['temple']?["name"].toString() ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF909090),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton(
                                  onPressed: (){},
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
                    );
                  })
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
