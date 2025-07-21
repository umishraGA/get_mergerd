import 'package:flutter/material.dart';

class DuaDetailScreen extends StatelessWidget {
  final String categoryTitle;
  final String duaTitle;
  final int duaIndex;

  const DuaDetailScreen({
    super.key,
    required this.categoryTitle,
    required this.duaTitle,
    required this.duaIndex,
  });

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Dua title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                duaTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Arabic text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _getArabicText(categoryTitle, duaIndex),
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 28,
                  height: 1.8,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Transliteration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _getTransliteration(categoryTitle, duaIndex),
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Translation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _getTranslation(categoryTitle, duaIndex),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Reference
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _getReference(categoryTitle, duaIndex),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // Action buttons
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
                    // Play audio
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
                    // Bookmark
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
                    // Share
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getArabicText(String category, int index) {
    if (category == 'Morning & Evening' && duaTitle == 'Waking Up') {
      return 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ';
    } else if (category == 'Morning & Evening') {
      return 'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ';
    } else if (category == 'Prayer & Daily Life') {
      return 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ';
    } else {
      return 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ';
    }
  }

  String _getTransliteration(String category, int index) {
    if (category == 'Morning & Evening' && duaTitle == 'Waking Up') {
      return 'Alhamdu lillahil-lathee ahyana baAAda ma amatana wa-ilayhin-nushoor.';
    } else if (category == 'Morning & Evening') {
      return 'Allahumma bika asbahna wa bika amsayna, wa bika nahya wa bika namutu wa ilaykan-nushur.';
    } else if (category == 'Prayer & Daily Life') {
      return 'Allahumma inni a\'udhu bika minal-hammi wal-hazan, wal-\'ajzi wal-kasal, wal-bukhli wal-jubn, wa dala\'id-dayni wa ghalabatir-rijal.';
    } else {
      return 'Bismillahir Rahmanir Raheem';
    }
  }

  String _getTranslation(String category, int index) {
    if (category == 'Morning & Evening' && duaTitle == 'Waking Up') {
      return 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.';
    } else if (category == 'Morning & Evening') {
      return 'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the Resurrection.';
    } else if (category == 'Prayer & Daily Life') {
      return 'O Allah, I seek refuge in You from grief and sadness, from weakness and laziness, from miserliness and cowardice, from being overcome by debt and overpowered by men.';
    } else {
      return 'In the name of Allah, the Most Beneficent, the Most Merciful.';
    }
  }

  String _getReference(String category, int index) {
    if (category == 'Morning & Evening' && duaTitle == 'Waking Up') {
      return 'Al-Bukhari 11:113, Muslim 4:2083';
    } else if (category == 'Morning & Evening') {
      return 'At-Tirmidhi 5:466';
    } else if (category == 'Prayer & Daily Life') {
      return 'Al-Bukhari 7:158';
    } else {
      return 'Quran 1:1';
    }
  }
}
