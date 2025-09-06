import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/features/events/controller/ticket_controller.dart';

class BookedTicketPage extends StatelessWidget {
  final BookedTicketController controller = Get.put(BookedTicketController());

  @override
  Widget build(BuildContext context) {
    controller.fetchBookedTickets(); // fetch tickets on page open

    return Scaffold(
      appBar: AppBar(title: const Text("My Booked Tickets")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.bookedTickets.isEmpty) {
          return const Center(child: Text("No tickets booked"));
        }

        return ListView.builder(
          itemCount: controller.bookedTickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.bookedTickets[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(ticket.event.eventTitle),
                subtitle: Text(
                  "Order: ${ticket.orderId}\n"
                      "Tickets: ${ticket.quantity}\n"
                      "Paid: ₹${ticket.custPaid}\n"
                      "Status: ${ticket.status}",
                ),
                trailing: const Icon(Icons.event_available),
              ),
            );
          },
        );
      }),
    );
  }
}
