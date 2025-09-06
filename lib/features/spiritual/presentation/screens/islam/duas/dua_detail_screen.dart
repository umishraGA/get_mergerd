import 'package:flutter/material.dart';

class DuaDetailScreen extends StatefulWidget {
  final dua;

  const DuaDetailScreen({
    super.key,
    required this.dua,
  });

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final dua = widget.dua;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Divider(),
            // Dua title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                dua.titleArabic?.toString() ?? 'No Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Divider(),

            // Arabic
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                dua.titleEnglish?.toString() ?? '' ?? '',
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 28,
                  height: 1.8,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Divider(),

            // Transliteration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                dua.arabicDua?.toString() ?? '',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Divider(),

            // Translation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                dua.englishDua?.toString() ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Divider(),

            // Reference
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                dua.referenceBook?.toString() ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Divider(),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.green,
                    size: 34,
                  ),
                  onPressed: () {
                    // TODO: Play audio
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    // TODO: Bookmark
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    // TODO: Share
                  },
                ),
              ],
            ),

            Divider(),
          ],
        ),
      ),
    );
  }
}
