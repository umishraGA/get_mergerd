import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import 'package:myapp/features/events/widgets/event_detail_card.dart';

import '../models/event_model.dart';
import '../widgets/category_filter.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String selectedCategory = 'All Events';
  List<Event> allEvents = [];
  List<Event> filteredEvents = [];
  List<Event> featuredEvents = [];

  @override
  void initState() {
    super.initState();
    // Load sample events
    allEvents = Event.getSampleEvents();
    featuredEvents = allEvents.where((event) => event.isFeatured).toList();
    _filterEvents();
  }

  void _filterEvents() {
    if (selectedCategory == 'All Events') {
      filteredEvents = allEvents;
    } else {
      filteredEvents = allEvents
          .where((event) =>
              event.category.toUpperCase() == selectedCategory.toUpperCase())
          .toList();
    }
    setState(() {});
  }

  void _onCategorySelected(String category) {
    selectedCategory = category;
    _filterEvents();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopAppBarCustom(),

            const SizedBox(height: 16),

            Bannercorousal(
              imagePaths: const [
                'assets/images/events/carnival_banner.png',
                'assets/images/events/carnival_banner.png',
                'assets/images/events/carnival_banner.png',
              ],
              height: isTablet ? 260 : 160,
            ),

            const SizedBox(height: 16),

            // Category Filter
            CategoryFilter(
              onCategorySelected: _onCategorySelected,
            ),

            const SizedBox(height: 20),

            // Featured Events
            if (featuredEvents.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Featured Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: isTablet ? 580 : 400,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  itemCount: featuredEvents.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.only(right: 16),
                      child: EventDetailCard(
                        event: featuredEvents[index],
                      ),
                    );
                  },
                ),
              ),
            ],

            const Divider(
              color: Color(0xFFEEEEEE),
              height: 1,
            ),

            const SizedBox(height: 16),

            // Upcoming Events
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Grid of Upcoming Events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredEvents.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No events found in this category'),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isTablet ? 1 : 0.7,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: filteredEvents[index],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
