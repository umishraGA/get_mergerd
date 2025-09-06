import 'package:flutter/material.dart';

class InterestPreferencesScreen extends StatefulWidget {
  const InterestPreferencesScreen({super.key});

  @override
  State<InterestPreferencesScreen> createState() =>
      _InterestPreferencesScreenState();
}

class _InterestPreferencesScreenState extends State<InterestPreferencesScreen> {
  // List of industries with selection state
  final List<Map<String, dynamic>> industries = [
    {'name': 'Restaurants', 'selected': true},
    {'name': 'Hotels', 'selected': true},
    {'name': 'Beauty', 'selected': true},
    {'name': 'Home Decor', 'selected': true},
    {'name': 'Education', 'selected': true},
    {'name': 'Hospitals', 'selected': false},
    {'name': 'Gym', 'selected': false},
    {'name': 'Event Organisers', 'selected': false},
    {'name': 'Packers & Movers', 'selected': false},
    {'name': 'Courier Service', 'selected': false},
  ];

  // Keep track of the number of selected industries
  int get selectedCount =>
      industries.where((i) => i['selected'] == true).length;

  // Maximum number of selections allowed
  final int maxSelections = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          'Interest Preferences',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose your industry for',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'precise matches ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '(up to 5)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List of industries
          Expanded(
            child: ListView.builder(
              itemCount: industries.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final industry = industries[index];
                final bool isSelected = industry['selected'] as bool;

                return InkWell(
                  onTap: () {
                    // Handle selection/deselection
                    if (isSelected || selectedCount < maxSelections) {
                      setState(() {
                        industry['selected'] = !isSelected;
                      });
                    } else {
                      // Show a snackbar if trying to select more than max
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You can select maximum $maxSelections industries'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          industry['name'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.brown[800],
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: Colors.grey[300]!, width: 1),
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Submit button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Return selected industries to the previous screen
                List<String> selectedIndustries = industries
                    .where((i) => i['selected'] == true)
                    .map<String>((i) => i['name'] as String)
                    .toList();
                Navigator.pop(context, selectedIndustries);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFF4A69B2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
