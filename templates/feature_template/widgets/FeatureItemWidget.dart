import 'package:flutter/material.dart';

/// Item widget for the Feature
///
/// This widget should:
/// 1. Display a single item
/// 2. Handle UI interactions
/// 3. Call callbacks for business logic
class FeatureItemWidget extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FeatureItemWidget({
    Key? key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 