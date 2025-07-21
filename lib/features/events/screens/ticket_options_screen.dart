import 'package:flutter/material.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../models/event_model.dart';
import './ticket_confirmation_screen.dart';

class TicketOptionsScreen extends StatefulWidget {
  final Event event;

  const TicketOptionsScreen({
    super.key,
    required this.event,
  });

  @override
  State<TicketOptionsScreen> createState() => _TicketOptionsScreenState();
}

class _TicketOptionsScreenState extends State<TicketOptionsScreen> {
  // Ticket quantities
  int standardTicketCount1 = 1;
  int standardTicketCount2 = 1;
  int vipTicketCount = 1;

  // Expanded state for know more
  bool isStandardExpanded1 = false;
  bool isStandardExpanded2 = false;

  // Calculate total price
  int get totalPrice {
    return (standardTicketCount1 * widget.event.price.toInt()) +
        (standardTicketCount2 * widget.event.price.toInt()) +
        (vipTicketCount * 1599);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Stack(
        children: [
          Column(
            children: [
              const AppHeader(title: "Ticket Options"),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Event Info Card
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event title
                            const Text(
                              'Radio City Joke Studio',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Date and time
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tue, 05 June 2025 | 05:00 PM',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Venue
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Ikana Stadium, Banglore',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Standard Ticket 1
                      _buildTicketOption(
                        title: 'ENTRY TICKET FOR ONE',
                        price: widget.event.price.toInt(),
                        count: standardTicketCount1,
                        onDecrease: () {
                          if (standardTicketCount1 > 1) {
                            setState(() {
                              standardTicketCount1--;
                            });
                          }
                        },
                        onIncrease: () {
                          setState(() {
                            standardTicketCount1++;
                          });
                        },
                        isExpanded: isStandardExpanded1,
                        onExpandToggle: () {
                          setState(() {
                            isStandardExpanded1 = !isStandardExpanded1;
                          });
                        },
                      ),

                      // Standard Ticket 2
                      _buildTicketOption(
                        title: 'ENTRY TICKET FOR ONE',
                        price: widget.event.price.toInt(),
                        count: standardTicketCount2,
                        onDecrease: () {
                          if (standardTicketCount2 > 1) {
                            setState(() {
                              standardTicketCount2--;
                            });
                          }
                        },
                        onIncrease: () {
                          setState(() {
                            standardTicketCount2++;
                          });
                        },
                        isExpanded: isStandardExpanded2,
                        onExpandToggle: () {
                          setState(() {
                            isStandardExpanded2 = !isStandardExpanded2;
                          });
                        },
                      ),

                      // VIP Ticket
                      _buildTicketOption(
                        title: 'VIP TICKET FOR ONE',
                        price: 1599,
                        count: vipTicketCount,
                        onDecrease: () {
                          if (vipTicketCount > 1) {
                            setState(() {
                              vipTicketCount--;
                            });
                          }
                        },
                        onIncrease: () {
                          setState(() {
                            vipTicketCount++;
                          });
                        },
                        isSoldOut: true,
                      ),

                      // Add space at the bottom for the fixed bottom container
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Fixed total and book button at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹$totalPrice',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFC6E30),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketConfirmationScreen(
                            event: widget.event,
                            quantity:
                                standardTicketCount1 + standardTicketCount2,
                            ticketPrice: widget.event.price,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE54B4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketOption({
    required String title,
    required int price,
    required int count,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
    VoidCallback? onExpandToggle,
    bool isSoldOut = false,
    bool isExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isSoldOut)
                      Row(
                        children: [
                          // Decrease button
                          InkWell(
                            onTap: onDecrease,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),

                          // Quantity display
                          Container(
                            width: 40,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.symmetric(
                                horizontal:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Increase button
                          InkWell(
                            onTap: onIncrease,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹$price',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFC6E30),
                      ),
                    ),
                    if (isSoldOut)
                      const Text(
                        'Sold Out',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
                if (!isSoldOut) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onExpandToggle,
                    child: Row(
                      children: [
                        const Text(
                          'Know more',
                          style: TextStyle(
                            color: Color(0xFF4976C2),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: const Color(0xFF4976C2),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Expanded content if isExpanded is true
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: const Text(
                'This ticket includes entry for one person. No reserved seating, first come first served basis.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
