import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../controller/create_ticket_order_for_payement.dart';

class TicketConfirmationScreen extends StatefulWidget {
  final List<Map<String, dynamic>> ticketData;
  final double totalPrice;
  final String eventId;
  final String eventDate;
  final String eventTitle;
  final String eventAddress;

  const TicketConfirmationScreen({
    super.key,
    required this.ticketData,
    required this.totalPrice,
    required this.eventId,
    required this.eventDate,
    required this.eventTitle,
    required this.eventAddress,
  });

  @override
  State<TicketConfirmationScreen> createState() =>
      _TicketConfirmationScreenState();
}

class _TicketConfirmationScreenState extends State<TicketConfirmationScreen> {
  final PaymentController paymentController = Get.put(PaymentController());

  late Map<String, dynamic> ticket;
  late double ticketPrice;
  late double subTotal;
  late double bookingFee;
  late double totalAmount;
  late int quantity;
  late String ticketName;
  late String ticketId;
  late String eventId;
  late String eventDate;

  @override
  void initState() {
    super.initState();

    // Extract ticket data from the list (assuming first ticket)
    ticket = widget.ticketData.first;

    // Parse the ticket data
    ticketId = ticket['ticketId']?.toString() ?? '';
    ticketName = ticket['ticketName']?.toString() ?? 'PAID TICKETS';
    quantity = int.parse(ticket['quantity'].toString());
    ticketPrice = double.parse((ticket['price'] ?? 0).toString());
    subTotal = double.parse((ticket['totalPrice'] ?? 0).toString());
    eventId = ticket['eventId']?.toString() ?? '';
    eventDate = ticket['eventDate']?.toString() ?? '';

    // Calculate booking fee (assuming 18% of subtotal)
    bookingFee = subTotal * 0.18;
    totalAmount = subTotal + bookingFee;

    _printTicketInfo();
  }

  // Option 2: Short format
  String _formatDateTime(String dateTimeString) {
    try {
      // Parse the string to DateTime
      DateTime dateTime = DateTime.parse(dateTimeString);

      // Convert to local time
      dateTime = dateTime.toLocal();

      // Format the DateTime
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  void _printTicketInfo() {
    print("""
=====================================
TICKET CONFIRMATION DETAILS
=====================================
Ticket ID: $ticketId 
Ticket Name: $ticketName
Quantity: $quantity
Price per Ticket: ₹${ticketPrice.toStringAsFixed(2)}
Sub-Total: ₹${subTotal.toStringAsFixed(2)}
Event ID: $eventId
Event Date: $eventDate
Booking Fee: ₹${bookingFee.toStringAsFixed(2)}
Total Amount: ₹${totalAmount.toStringAsFixed(2)}
=====================================
""");
  }

  void _onProceedToPay() {
    print("""
=====================================
PROCEEDING TO PAYMENT
=====================================
Payment Details:
- Customer proceeding to pay for $quantity ticket(s)
- Event: Radio City Joke Studio
- Ticket Type: $ticketName
- Ticket ID: $ticketId
- Event ID: $eventId
- Event Date: $eventDate
- Ticket Quantity: $quantity
- Amount to be charged: ₹${totalAmount.toStringAsFixed(2)}
- Breakdown:
  * Ticket Cost: ₹${subTotal.toStringAsFixed(2)}
  * Booking Fee: ₹${bookingFee.toStringAsFixed(2)}
  * Total: ₹${totalAmount.toStringAsFixed(2)}
=====================================
""");
    paymentController.createPaymentOrder(
      eventId: eventId,
      ticketId: ticketId,
      quantity: quantity,
      bookedDate: eventDate,
      // bookedDate: DateTime.now().toUtc().toIso8601String(),
      context: context,
    );
  }

  void _onBookFreeTicket() {
    print("""
=====================================
BOOKING FREE TICKET
=====================================
Free Ticket Details:
- Customer booking free ticket for $quantity ticket(s)
- Event: Radio City Joke Studio
- Ticket Type: $ticketName
- Ticket ID: $ticketId
- Event ID: $eventId
- Event Date: $eventDate
- Ticket Quantity: $quantity
- Total Amount: ₹${totalAmount.toStringAsFixed(2)} (Free)
=====================================
""");
    // Call your free ticket booking function herepa
    paymentController.freeTicketBook(eventId: eventId,
        tickettype: ticketId,
        quantity: quantity,
        bookedDate: eventDate,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        children: [
          const AppHeader(title: "Ticket Confirmation"),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // M-Ticket Information
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'M-Ticket Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "1. Customer(s) can access their ticket(s) from the 'My Profile' section on the app/mobile-web.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "2. It is mandatory to present the ticket(s) in my profile section via app/mobile-web at the venue.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "3. No physical ticket(s) are required to enter the venue",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Event Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.eventTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$quantity Ticket${quantity > 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              totalAmount == 0 ? 'Free' : '₹${subTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: totalAmount == 0 ? Colors.green : Color(0xFFFC6E30),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  const SizedBox(height: 16),

                  // Date and Venue
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDateTime(widget.eventDate),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 24),
                        Text(
                          widget.eventAddress,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  const SizedBox(height: 16),

                  // Ticket Summary
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          totalAmount == 0
                              ? 'FREE ENTRY TICKET FOR ONE : $quantity Ticket(s)'
                              : 'ENTRY TICKET FOR ONE (₹${ticketPrice.toStringAsFixed(0)}) : $quantity Ticket(s)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ticket Type: $ticketName',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sub-Total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              totalAmount == 0 ? 'Free' : '₹${subTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: totalAmount == 0 ? Colors.green : Color(0xFFFC6E30),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (totalAmount > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Booking Fee',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                '₹${bookingFee.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  const SizedBox(height: 16),

                  // Total Amount
                  if (totalAmount > 0) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFC6E30),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Payment Button with Loader
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Obx(() {
                      final bool isLoading = paymentController.isLoading.value;

                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : totalAmount == 0
                            ? _onBookFreeTicket
                            : _onProceedToPay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: totalAmount == 0
                              ? Colors.green
                              : const Color(0xFFE54B4D),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          disabledBackgroundColor: Colors.grey[400],
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          totalAmount == 0 ? 'Confirm Booking' : 'Proceed to Pay',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),

                  // Bottom padding for the button
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
