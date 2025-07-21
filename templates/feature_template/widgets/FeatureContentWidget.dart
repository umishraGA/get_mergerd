import 'package:flutter/material.dart';

import 'FeatureItemWidget.dart';

/// Main content widget for the Feature page
///
/// This widget should contain:
/// 1. The UI structure for the feature
/// 2. Composition of smaller widgets
/// 3. No business logic (only UI logic)
///
/// Business logic should be in the main page
class FeatureContentWidget extends StatelessWidget {
  final Function(int) onItemTap;

  const FeatureContentWidget({
    Key? key,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return FeatureItemWidget(
          id: index,
          title: 'Item $index',
          subtitle: 'Description for item $index',
          onTap: () => onItemTap(index),
        );
      },
    );
  }
}
