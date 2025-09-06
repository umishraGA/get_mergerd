import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class PanchangDetailsScreen extends StatefulWidget {
  const PanchangDetailsScreen({super.key});

  @override
  State<PanchangDetailsScreen> createState() => _PanchangDetailsScreenState();
}

class _PanchangDetailsScreenState extends State<PanchangDetailsScreen> {
  String selectedLocation = 'Lucknow, Uttar Pradesh';

  // Use DateTime instead of String for date management
  DateTime selectedDateTime = DateTime.now();

  // Format the date for display
  String get selectedDate {
    return '${_getDayName(selectedDateTime.weekday)} ${selectedDateTime.day} ${_getMonthName(selectedDateTime.month)} ${selectedDateTime.year}';
  }

  // Helper to get day name
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  // Helper to get month name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  // Move to previous day
  void _goToPreviousDay() {
    setState(() {
      selectedDateTime = selectedDateTime.subtract(const Duration(days: 1));
    });
  }

  // Move to next day
  void _goToNextDay() {
    setState(() {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    });
  }

  // Open date picker
  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2D1D50), // Header background
              onPrimary: Colors.white, // Header text
              onSurface: Colors.black, // Calendar text
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateTime) {
      setState(() {
        selectedDateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(title: 'Panchang Details'),
            const SizedBox(height: 16),

            // Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                selectedLocation,
                style: AppTextStyles.medium15.copyWith(
                  color: const Color(0xFFEF3340),
                ),
              ),
            ),

            // Date Selector
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D1D50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: _goToPreviousDay,
                  ),
                  GestureDetector(
                    onTap: _openDatePicker,
                    child: Row(
                      children: [
                        Text(
                          selectedDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: _goToNextDay,
                  ),
                ],
              ),
            ),

            // Tithi Section
            _buildSection(
              'Tithi:',
              [
                _buildTimeRow('Dashami', '24th 05:38 am to 25th 05:05 am'),
                _buildTimeRow('Ekadashi', '25th 05:05 am to 26th 03:45 am'),
              ],
            ),

            // Auspicious Section
            _buildSection(
              'Auspicious',
              [
                _buildMultiTimeRow([
                  TimeInfo('Abhijit Muhurat', '24th 11:48 am to 24th 12:36 pm'),
                  TimeInfo('Amrit Kaal', '24th 09:59 pm to 24th 11:35 pm'),
                  TimeInfo('Brahma Muhurat', '24th 04:32 am to 24th 05:20 am'),
                ]),
              ],
              isAuspicious: true,
            ),

            // Inauspicious Section
            _buildSection(
              'Inauspicious',
              [
                _buildMultiTimeRow([
                  TimeInfo('Rahu', '24th 07:40 am to 24th 09:10 am'),
                  TimeInfo('Yamaganda', '24th 10:41 pm to 24th 12:12 pm'),
                  TimeInfo('Gulika', '24th 01:43 pm to 24th 03:13 pm'),
                ]),
                _buildMultiTimeRow([
                  TimeInfo('Dur Muhurat', '24th 12:36 pm to 24th 01:24 pm'),
                  TimeInfo('Varjyam', '24th 12:21 pm to 24th 01:58 pm'),
                ]),
                _buildTimeRow('', '24th 03:01 pm to 24th 03:50 pm'),
              ],
              isInauspicious: true,
            ),

            // Nakshatra Section
            _buildSection(
              'Nakshatra',
              [
                // _buildTimeRow(
                //     'Uttara Ashadha', '24th 04:18 am to 25th 04:26 am'),
                _buildTimeRow('Shravana', '25th 04:26 am to 26th 03:49 am'),
              ],
            ),

            // Yoga Section
            _buildSection(
              'Yoga',
              [
                _buildTimeRow('Parigha', '23rd 05:58 pm to 24th 04:44 pm'),
                _buildTimeRow('Siva', '24th 04:44 pm to 25th 02:53 pm'),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children,
      {bool isAuspicious = false, bool isInauspicious = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isAuspicious
                        ? const Color(0xFF4CAF50)
                        : isInauspicious
                            ? const Color(0xFFEF3340)
                            : const Color(0xFFEF3340),
                  ),
                ),
                if (isAuspicious || isInauspicious)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAuspicious
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFEF3340),
                    ),
                  ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTimeRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (title.isNotEmpty) const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TimeInfo {
  final String title;
  final String time;

  TimeInfo(this.title, this.time);
}

Widget _buildMultiTimeRow(List<TimeInfo> timeInfos) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(timeInfos.length * 2 - 1, (index) {
        // If index is even, show time info
        if (index % 2 == 0) {
          final timeInfo = timeInfos[index ~/ 2];
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeInfo.title,
                  style: AppTextStyles.medium14.copyWith(
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  timeInfo.time,
                  style: AppTextStyles.regular12.copyWith(
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          );
        } else {
          // Render separator
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 1,
              height: 40,
              color: Colors.grey.withOpacity(0.3),
            ),
          );
        }
      }),
    ),
  );
}
