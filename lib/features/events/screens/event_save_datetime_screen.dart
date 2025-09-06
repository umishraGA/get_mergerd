import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/events/screens/ticket_options_screen.dart';

class SelectDataTime extends StatefulWidget {
  final List<String> startDateTime; // <-- FIX: accept list
  final String eventId;

  const SelectDataTime({
    Key? key,
    required this.startDateTime,
    required this.eventId,
  }) : super(key: key);

  @override
  State<SelectDataTime> createState() => _EventBookingPageState();
}

class _EventBookingPageState extends State<SelectDataTime> {
  String? selectedDate;
  String? selectedTimeDisplay; // For showing in UI
  String? selectedFullDateTime; // The exact ISO timestamp

  @override
  Widget build(BuildContext context) {
    // ✅ Create a list of unique dates
    List<String> dates = widget.startDateTime
        .map((dateTime) =>
        DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTime).toLocal()))
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Date & Time"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // ✅ Date Selector
            Wrap(
              spacing: 8,
              children: dates.map((date) {
                String label =
                DateFormat('E dd MMM').format(DateTime.parse(date));
                return ChoiceChip(
                  label: Text(label),
                  selected: selectedDate == date,
                  selectedColor: Colors.red,
                  onSelected: (_) {
                    setState(() {
                      selectedDate = date;
                      selectedTimeDisplay = null;
                      selectedFullDateTime = null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ✅ Time Slots for Selected Date
            if (selectedDate != null) ...[
              const Text("Available Times",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.startDateTime.map((dateTime) {
                  DateTime start = DateTime.parse(dateTime).toLocal();
                  String dateOnly = DateFormat('yyyy-MM-dd').format(start);

                  if (dateOnly == selectedDate) {
                    String timeSlot =
                    DateFormat('hh:mm a').format(start);
                    bool isSelected = selectedTimeDisplay == timeSlot;

                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                        isSelected ? Colors.red : Colors.transparent,
                        foregroundColor:
                        isSelected ? Colors.white : Colors.black,
                        side: BorderSide(
                            color: isSelected ? Colors.blue : Colors.grey),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTimeDisplay = timeSlot;
                          selectedFullDateTime = dateTime; // ISO timestamp
                        });
                      },
                      child: Text(timeSlot),
                    );
                  }
                  return const SizedBox.shrink();
                }).toList(),
              ),
            ],

            const Spacer(),

            // ✅ Book Ticket Button
            ElevatedButton(
              onPressed: (selectedDate != null && selectedFullDateTime != null)
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketOptionsScreen(
                      eventId: widget.eventId,
                      selectedDateTime: selectedFullDateTime!,
                    ),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                "Book Ticket",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
