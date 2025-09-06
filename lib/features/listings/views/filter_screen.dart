import 'package:flutter/material.dart';
import 'package:myapp/features/listings/widgets/VendorCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import 'vendor_list_page.dart';

class AyurvedicDoctorsPage extends StatefulWidget {
  const AyurvedicDoctorsPage({super.key});

  @override
  State<AyurvedicDoctorsPage> createState() => _AyurvedicDoctorsPageState();
}

class _AyurvedicDoctorsPageState extends State<AyurvedicDoctorsPage> {
  String _selectedSort = 'Most Relevant';
  String _selectedRating = 'Any';

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...[
                'Most Relevant',
                'Rating: High to Low',
                'Rating: Low to High',
                'Distance: Near to Far',
                'Distance: Far to Near',
              ].map((option) => _buildSortOption(option)),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String option) {
    final isSelected = _selectedSort == option;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSort = option;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFFED3237) : Colors.grey[400]!,
                  width: 2,
                ),
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFFED3237) : Colors.white,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingsBottomSheet() {
    String tempSelectedRating =
        _selectedRating; // Temporary state for the bottom sheet

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          // Use StatefulBuilder to rebuild bottom sheet content
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ratings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Horizontal ratings selector
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            'Any',
                            '3.5+',
                            '4.0+',
                            '4.5+',
                            '5',
                          ]
                              .map((option) => InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        tempSelectedRating = option;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: tempSelectedRating == option
                                            ? const Color(0xFFED3237)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: tempSelectedRating == option
                                              ? const Color(0xFFED3237)
                                              : Colors.grey[400]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: tempSelectedRating == option
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),

                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedRating = tempSelectedRating;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED3237),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedRating = 'Any';
                            });
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFED3237),
                          ),
                          child: const Text(
                            'Clear Filters',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCombinedFiltersBottomSheet() {
    String tempSelectedRating = _selectedRating;
    String tempSelectedSort = _selectedSort;
    bool tempIsVerified = false;
    RangeValues tempPriceRange = const RangeValues(0, 5000);
    List<String> tempSelectedSpecialties = [];
    List<String> tempSelectedAvailability = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with title and close button
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable filter options
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sort options
                            const Text(
                              'Sort By',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                'Most Relevant',
                                'Rating: High to Low',
                                'Rating: Low to High',
                                'Distance: Near to Far',
                                'Distance: Far to Near',
                              ]
                                  .map((option) => InkWell(
                                        onTap: () {
                                          setModalState(() {
                                            tempSelectedSort = option;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: tempSelectedSort == option
                                                ? const Color(0xFFED3237)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: tempSelectedSort == option
                                                  ? const Color(0xFFED3237)
                                                  : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: tempSelectedSort == option
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),

                            const SizedBox(height: 24),

                            // Ratings filter
                            const Text(
                              'Ratings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                'Any',
                                '3.5+',
                                '4.0+',
                                '4.5+',
                                '5',
                              ]
                                  .map((option) => InkWell(
                                        onTap: () {
                                          setModalState(() {
                                            tempSelectedRating = option;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: tempSelectedRating == option
                                                ? const Color(0xFFED3237)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color:
                                                  tempSelectedRating == option
                                                      ? const Color(0xFFED3237)
                                                      : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  tempSelectedRating == option
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),

                            const SizedBox(height: 24),

                            // HB Verified toggle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'HB Verified',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: tempIsVerified,
                                  onChanged: (value) {
                                    setModalState(() {
                                      tempIsVerified = value;
                                    });
                                  },
                                  activeColor: const Color(0xFFED3237),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Price range slider
                            const Text(
                              'Price Range',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${tempPriceRange.start.round()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '₹${tempPriceRange.end.round()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: tempPriceRange,
                              min: 0,
                              max: 5000,
                              divisions: 50,
                              activeColor: const Color(0xFFED3237),
                              inactiveColor: Colors.grey[300],
                              labels: RangeLabels(
                                '₹${tempPriceRange.start.round()}',
                                '₹${tempPriceRange.end.round()}',
                              ),
                              onChanged: (values) {
                                setModalState(() {
                                  tempPriceRange = values;
                                });
                              },
                            ),

                            const SizedBox(height: 24),

                            // Specialties
                            const Text(
                              'Specialties',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                'Arthritis',
                                'Skin Diseases',
                                'Digestion',
                                'Weight Management',
                                'Mental Health',
                                'Panchakarma',
                              ]
                                  .map((option) => InkWell(
                                        onTap: () {
                                          setModalState(() {
                                            if (tempSelectedSpecialties
                                                .contains(option)) {
                                              tempSelectedSpecialties
                                                  .remove(option);
                                            } else {
                                              tempSelectedSpecialties
                                                  .add(option);
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: tempSelectedSpecialties
                                                    .contains(option)
                                                ? const Color(0xFFED3237)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: tempSelectedSpecialties
                                                      .contains(option)
                                                  ? const Color(0xFFED3237)
                                                  : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: tempSelectedSpecialties
                                                      .contains(option)
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),

                            const SizedBox(height: 24),

                            // Availability
                            const Text(
                              'Availability',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                'Today',
                                'Tomorrow',
                                'This Week',
                                'Weekend',
                              ]
                                  .map((option) => InkWell(
                                        onTap: () {
                                          setModalState(() {
                                            if (tempSelectedAvailability
                                                .contains(option)) {
                                              tempSelectedAvailability
                                                  .remove(option);
                                            } else {
                                              tempSelectedAvailability
                                                  .add(option);
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: tempSelectedAvailability
                                                    .contains(option)
                                                ? const Color(0xFFED3237)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: tempSelectedAvailability
                                                      .contains(option)
                                                  ? const Color(0xFFED3237)
                                                  : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: tempSelectedAvailability
                                                      .contains(option)
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Action buttons at the bottom
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedRating = 'Any';
                                _selectedSort = 'Most Relevant';
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Clear All'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedRating = tempSelectedRating;
                                _selectedSort = tempSelectedSort;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFED3237),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with location
            const AppHeader(
              title: 'Ayurvedic Doctors',
              subtitle: 'Mattyari,Lucknow - 226028',
              showDropdown: true,
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Carousel
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/utsav/banners/limited_time_offer.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Filter buttons row
                    _buildFilterRow(),

                    // Search results count
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 10),
                      child: Text(
                        '200 Results for your Search',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    // Clinic listings
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          _buildFilterButton(
            'All Filters',
            icon: Icons.filter_list,
            isFirst: true,
            // onTap: _showCombinedFiltersBottomSheet,
          ),
          _buildFilterButton(
            'Sort By',
            icon: Icons.sort,
            showDropdown: true,
            onTap: _showSortBottomSheet,
          ),
          _buildFilterButton(
            'Ratings',
            showDropdown: true,
            onTap: _showRatingsBottomSheet,
          ),
          _buildFilterButton(
            'HB Verified',
            showDropdown: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String label, {
    IconData? icon,
    bool showDropdown = false,
    bool isFirst = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: isFirst ? 4 : 0),
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8F9FA),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFDADCE0)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
            if (showDropdown) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Colors.black,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
