import 'package:flutter/material.dart';
import 'package:myapp/features/posts/widgets/NetworkImageWidget.dart';

/// A debug widget to test AVIF loading
class AvifTestWidget extends StatelessWidget {
  const AvifTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AVIF Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Testing AVIF Image Loading:'),
            const SizedBox(height: 16),
            
            // Test with a sample AVIF URL
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const NetworkImageWidget(
                imageUrl: 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.avif',
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 16),
            const Text('If you see a green AVIF badge and the image loads, AVIF support is working!'),
            
            const SizedBox(height: 16),
            
            // Test with a regular image for comparison
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const NetworkImageWidget(
                imageUrl: 'https://picsum.photos/300/200',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Regular image (no AVIF badge)'),
          ],
        ),
      ),
    );
  }
}