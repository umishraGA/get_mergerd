import 'package:flutter/material.dart';

class DuaCategoryScreen extends StatelessWidget {
  final String title;
  final int count;

  const DuaCategoryScreen({
    super.key,
    required this.title,
    required this.count,
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
      body: Column(
        children: [
          // Banner image with title
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  _getBannerImagePath(title),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
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
                  left: 24,
                  bottom: 24,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of duas
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _getDuasList(title).length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final dua = _getDuasList(title)[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  title: Text(
                    dua,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/spiritual/islam/duas/detail',
                      arguments: {
                        'categoryTitle': title,
                        'duaTitle': dua,
                        'duaIndex': index,
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getBannerImagePath(String category) {
    return 'assets/images/spiritual/islam/duas/${category.toLowerCase().replaceAll(' & ', '_').replaceAll(' ', '_')}.jpg';
  }

  List<String> _getDuasList(String category) {
    if (category == 'Morning & Evening') {
      return [
        'Waking Up',
        'Before sleeping',
        'When turning over during sleep',
        'Upon experience unrest, fear, apprehensiveness during sleep',
        'Upon seeing a good or bad dream Up',
        'Remembrance in the morning and evening',
      ];
    } else if (category == 'Prayer & Daily Life') {
      return [
        'Before beginning wudu',
        'After completing wudu',
        'When entering the mosque',
        'When leaving the mosque',
        'Before reciting the Quran',
        'When hearing the adhan',
        'When breaking fast',
        'Before eating',
      ];
    } else if (category == 'Joy & Stress') {
      return [
        'For anxiety and sorrow',
        'For depression and grief',
        'For stress relief',
      ];
    } else if (category == 'Sickness & Death') {
      return [
        'When visiting the sick',
        'For protection from diseases',
        'For fever and pain',
        'For healing',
        'When someone dies',
        'At the time of burial',
        'When visiting graves',
        'For the deceased',
      ];
    } else if (category == 'Nature') {
      return [
        'When it rains',
        'After rainfall',
        'When there is wind',
        'When seeing the new moon',
        'When seeing lightning',
        'When hearing thunder',
        'When seeing the stars',
        'When looking at the sky',
      ];
    } else if (category == 'Normal Routine') {
      return [
        'When entering the house',
        'When leaving the house',
        'When entering the bathroom',
        'When leaving the bathroom',
        'When getting dressed',
        'When looking in the mirror',
        'When entering the market',
        'When finishing a gathering',
      ];
    } else if (category == 'Praising for Kindness') {
      return [
        'For the one who does you a favor',
        'When someone says they love you for Allah\'s sake',
        'For the one who offers you food or drink',
        'For the host',
        'For the one who lends you money',
      ];
    } else {
      return [];
    }
  }
}
