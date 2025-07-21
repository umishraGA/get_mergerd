import 'package:flutter/material.dart';

class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          DuasCategoryCard(
            title: 'Morning & Evening',
            imagePath: 'assets/images/spiritual/islam/duas/morning.jpg',
            count: 6,
          ),
          SizedBox(height: 12),
          DuasCategoryCard(
            title: 'Prayer & Daily Life',
            imagePath: 'assets/images/spiritual/islam/duas/prayer.jpg',
            count: 8,
          ),
          SizedBox(height: 12),
          DuasCategoryCard(
            title: 'Joy & Stress',
            imagePath: 'assets/images/spiritual/islam/duas/joy.jpg',
            count: 3,
          ),
          SizedBox(height: 12),
          DuasCategoryCard(
            title: 'Sickness & Death',
            imagePath: 'assets/images/spiritual/islam/duas/sickness.jpg',
            count: 8,
          ),
          SizedBox(height: 12),
          DuasCategoryCard(
            title: 'Nature',
            imagePath: 'assets/images/spiritual/islam/duas/nature.jpg',
            count: 8,
          ),
          SizedBox(height: 12),
          DuasCategoryCard(
            title: 'Normal Routine',
            imagePath: 'assets/images/spiritual/islam/duas/routine.jpg',
            count: 8,
          ),
          SizedBox(height: 12),
          DuasCategoryCard(
            title: 'Praising for Kindness',
            imagePath: 'assets/images/spiritual/islam/duas/kindness.jpg',
            count: 5,
          ),
          SizedBox(height: 12),
          DuasCategoryCard(
            title: 'Travel',
            imagePath: 'assets/images/spiritual/islam/duas/travel.jpg',
            count: 0,
          ),
        ],
      ),
    );
  }
}

class DuasCategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final int count;

  const DuasCategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (count > 0) {
          Navigator.pushNamed(
            context,
            '/spiritual/islam/duas/category',
            arguments: {
              'title': title,
              'count': count,
            },
          );
        }
      },
      child: Container(
        height: 120,
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
            if (count > 0)
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
