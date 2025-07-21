import 'package:flutter/material.dart';

import 'widgets/FeatureContentWidget.dart';

/// Main page for the Feature
///
/// This class should contain:
/// 1. The page structure
/// 2. Business logic and state management
/// 3. Event handlers
///
/// UI components should be in the widgets folder
class FeaturePage extends StatefulWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  // State variables
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Business logic methods
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load data from API or other sources
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      // Handle errors
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Event handlers
  void _handleItemTap(int id) {
    // Handle item tap
    print('Item tapped: $id');
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: const Text('Dialog content goes here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle add item
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FeatureContentWidget(
              onItemTap: _handleItemTap,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
