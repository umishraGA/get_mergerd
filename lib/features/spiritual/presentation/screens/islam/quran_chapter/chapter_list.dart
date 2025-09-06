import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Islam_controller/quran_chapter_controller.dart';
import 'chapter_detail.dart'; // adjust path

class QuranChaptersPage extends StatelessWidget {
  const QuranChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranChapterController controller = Get.put(QuranChapterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quran Chapters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chapterList.isEmpty) {
          return const Center(child: Text('No chapters available.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.chapterList.length,
          itemBuilder: (context, index) {
            final chapter = controller.chapterList[index];

            return Card(
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuranVersesPage(chapterId: chapter.id),
                      ),
                    );
                    print("chapterId: ${chapter.id}");
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        chapter.sortingNo.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// English Name
                        Text(
                          chapter.englishName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        /// Meaning
                        const SizedBox(height: 4),
                        Text(
                          chapter.meaning,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        /// Total Verses with Icon
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.menu_book_rounded, size: 18, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              'Total Verses: ${chapter.totalVerses}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      chapter.arabicName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuranVersesPage(chapterId: chapter.id),
                        ),
                      );
                      print("chapterId: ${chapter.id}");
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
