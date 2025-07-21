class Event {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String time;
  final String venue;
  final String location;
  final double price;
  final String imagePath;
  final bool isFeatured;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.venue,
    required this.location,
    required this.price,
    required this.imagePath,
    this.isFeatured = false,
  });

  // Sample data for demo purposes
  static List<Event> getSampleEvents() {
    return [
      Event(
        id: '1',
        title: 'Radio City Joke Studio',
        category: 'ENTERTAINMENT',
        date: DateTime(2025, 6, 5),
        time: '05:00 PM',
        venue: 'Ikana Stadium',
        location: 'Banglore',
        price: 499,
        imagePath: 'assets/images/events/featured_event_img.png',
        isFeatured: true,
      ),
      Event(
        id: '2',
        title: 'Radio City Joke Studio',
        category: 'ENTERTAINMENT',
        date: DateTime(2025, 6, 5),
        time: '05:00 PM',
        venue: 'Ikana Stadium',
        location: 'Banglore',
        price: 499,
        imagePath: 'assets/images/events/featured_event_img.png',
        isFeatured: true,
      ),
      Event(
        id: '3',
        title: 'Radio City Joke Studio',
        category: 'ENTERTAINMENT',
        date: DateTime(2025, 6, 5),
        time: '05:00 PM',
        venue: 'Ikana Stadium',
        location: 'Banglore',
        price: 499,
        imagePath: 'assets/images/events/featured_event_img.png',
      ),
      Event(
        id: '4',
        title: 'Radio City Joke Studio',
        category: 'ENTERTAINMENT',
        date: DateTime(2025, 6, 5),
        time: '05:00 PM',
        venue: 'Ikana Stadium',
        location: 'Banglore',
        price: 499,
        imagePath: 'assets/images/events/featured_event_img.png',
      ),
      Event(
        id: '5',
        title: 'Radio City Joke Studio',
        category: 'ENTERTAINMENT',
        date: DateTime(2025, 6, 5),
        time: '05:00 PM',
        venue: 'Ikana Stadium',
        location: 'Banglore',
        price: 499,
        imagePath: 'assets/images/events/featured_event_img.png',
      ),
      Event(
        id: '6',
        title: 'Radio City Joke Studio',
        category: 'ENTERTAINMENT',
        date: DateTime(2025, 6, 5),
        time: '05:00 PM',
        venue: 'Ikana Stadium',
        location: 'Banglore',
        price: 499,
        imagePath: 'assets/images/events/featured_event_img.png',
      ),
    ];
  }
}
