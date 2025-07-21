import 'package:flutter/material.dart';

import 'asma_al_husna_model.dart';

class AsmaNameDetailScreen extends StatelessWidget {
  final AsmaAlHusnaName name;

  const AsmaNameDetailScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2639),
        elevation: 0,
        centerTitle: true,
        title: Text(
          name.name.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
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
                  name.name.toUpperCase(),
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
                  name.arabicText,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 30,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // English Meaning
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text(
                name.englishMeaning.isEmpty
                    ? name.name.toUpperCase()
                    : name.englishMeaning,
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
                    name.description.isNotEmpty
                        ? name.description
                        : name.meaning,
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
                    name.benefits.isNotEmpty
                        ? name.benefits
                        : 'Reciting this name brings you closer to Allah and His mercy.',
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
      ),
    );
  }
}
