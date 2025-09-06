import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/events/screens/ticket_confirmation_screen.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import '../controller/ticket_option_controller.dart';

class TicketOptionsScreen extends StatefulWidget {
  final String eventId;
  final String selectedDateTime;

  const TicketOptionsScreen({
    Key? key,
    required this.eventId,
    required this.selectedDateTime,
  }) : super(key: key);

  @override
  State<TicketOptionsScreen> createState() => _TicketOptionsScreenState();
}

class _TicketOptionsScreenState extends State<TicketOptionsScreen> {
  final TicketController ticketController = Get.put(TicketController());
  final Map<String, int> selectedTickets = {}; // {ticketId_variation: quantity}
  String? selectedTicketType; // Track which ticket type is selected
  double totalPrice = 0.0;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeTickets();
  }

  Future<void> _initializeTickets() async {
    try {
      await ticketController.fetchTickets(widget.eventId);
      _initializeSelectedQuantities();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tickets: ${e.toString()}');
    }
  }

  void _initializeSelectedQuantities() {
    if (mounted && !isInitialized) {
      setState(() {
        selectedTickets.clear();
        for (var ticket in ticketController.tickets) {
          if (ticket['price'] == 'variation_wise') {
            final variations = ticket['variation_name'] as List<dynamic>? ?? [];
            for (var variation in variations) {
              selectedTickets['${ticket['_id']}_$variation'] = 0;
            }
          } else {
            selectedTickets[ticket['_id'].toString()] = 0;
          }
        }
        isInitialized = true;
      });
    }
  }

  void updateTicketQuantity(String ticketKey, int newQuantity) {
    if (mounted) {
      setState(() {
        // If selecting a new ticket and we already have a selection, clear others
        if (newQuantity > 0 && selectedTicketType != null && selectedTicketType != ticketKey) {
          // Clear all other selections
          selectedTickets.updateAll((key, value) => 0);
        }

        selectedTickets[ticketKey] = newQuantity;

        // Update selected ticket type
        if (newQuantity > 0) {
          selectedTicketType = ticketKey;
        } else if (selectedTickets.values.every((qty) => qty == 0)) {
          selectedTicketType = null;
        }

        calculateTotalPrice();
      });
    }
  }

  void calculateTotalPrice() {
    double newTotal = 0.0;

    try {
      for (var ticket in ticketController.tickets) {
        if (ticket['price'] == 'variation_wise') {
          final variations = ticket['variation_name'] as List<dynamic>? ?? [];
          final prices = ticket['variation_price'] as List<dynamic>? ?? [];

          for (int i = 0; i < variations.length; i++) {
            final ticketKey = '${ticket['_id']}_${variations[i]}';
            final quantity = selectedTickets[ticketKey] ?? 0;

            if (i < prices.length) {
              final price = _parsePrice(prices[i]);
              newTotal += price * quantity;
            }
          }
        } else {
          final quantity = selectedTickets[ticket['_id']] ?? 0;
          final price = _parsePrice(ticket['without_variation_price']);
          newTotal += price * quantity;
        }
      }
    } catch (e) {
      print('Error calculating total price: $e');
    }

    if (mounted) {
      setState(() {
        totalPrice = newTotal;
      });
    }
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    return double.tryParse(price.toString()) ?? 0.0;
  }

  int _parseLimit(dynamic limit) {
    if (limit == null) return 0;
    if (limit is int) return limit;
    return int.tryParse(limit.toString()) ?? 0;
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    if (ticket['price'] == 'variation_wise') {
      return _buildVariationTickets(ticket);
    } else {
      return _buildStandardTicket(ticket);
    }
  }

  Widget _buildVariationTickets(Map<String, dynamic> ticket) {
    final variations = ticket['variation_name'] as List<dynamic>? ?? [];
    final prices = ticket['variation_price'] as List<dynamic>? ?? [];
    final availTypes = ticket['avail_ticket'] as List<dynamic>? ?? [];
    final limits = ticket['limited_ticket'] as List<dynamic>? ?? [];

    if (variations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Ticket type header
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                ticket['ticket_name']?.toString() ?? 'Ticket',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        // Variation tickets
        ...variations.asMap().entries.map<Widget>((entry) {
          final index = entry.key;
          final variation = entry.value;
          final ticketKey = '${ticket['_id']}_$variation';
          final isLimited = index < availTypes.length &&
              availTypes[index].toString().toLowerCase() == 'limited';
          final limit = isLimited && index < limits.length
              ? _parseLimit(limits[index])
              : 0;
          final price = index < prices.length ? prices[index] : 0;
          final currentQuantity = selectedTickets[ticketKey] ?? 0;

          return _buildTicketItem(
            name: variation.toString(),
            price: price,
            quantity: currentQuantity,
            limit: limit,
            isLimited: isLimited,
            ticketKey: ticketKey,
            onIncrement: () {
              if (!isLimited || currentQuantity < limit) {
                updateTicketQuantity(ticketKey, currentQuantity + 1);
              } else {
                _showLimitReachedSnackbar();
              }
            },
            onDecrement: () {
              if (currentQuantity > 0) {
                updateTicketQuantity(ticketKey, currentQuantity - 1);
              }
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStandardTicket(Map<String, dynamic> ticket) {
    final ticketKey = ticket['_id'].toString();
    final currentQuantity = selectedTickets[ticketKey] ?? 0;
    final price = _parsePrice(ticket['without_variation_price']);

    // Handle limited ticket logic more safely
    final availTicket = ticket['avail_ticket'];
    final isLimited = availTicket != null &&
        (availTicket is List
            ? availTicket.any((item) => item.toString().toLowerCase() == 'limited')
            : availTicket.toString().toLowerCase() == 'limited');

    int limit = 0;
    if (isLimited) {
      final limitedTicket = ticket['limited_ticket'];
      if (limitedTicket is List && limitedTicket.isNotEmpty) {
        limit = _parseLimit(limitedTicket.first);
      } else {
        limit = _parseLimit(limitedTicket);
      }
    }

    return _buildTicketItem(
      name: ticket['ticket_name']?.toString() ?? 'Standard Ticket',
      price: price,
      quantity: currentQuantity,
      limit: limit,
      isLimited: isLimited,
      ticketKey: ticketKey,
      onIncrement: () {
        if (!isLimited || currentQuantity < limit) {
          updateTicketQuantity(ticketKey, currentQuantity + 1);
        } else {
          _showLimitReachedSnackbar();
        }
      },
      onDecrement: () {
        if (currentQuantity > 0) {
          updateTicketQuantity(ticketKey, currentQuantity - 1);
        }
      },
      description: ticket['description']?.toString(),
    );
  }

  void _showLimitReachedSnackbar() {
    Get.snackbar(
      'Limit Reached',
      'Maximum tickets reached for this option',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

  Widget _buildTicketItem({
    required String name,
    required dynamic price,
    required int quantity,
    required int limit,
    required bool isLimited,
    required String ticketKey,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    String? description,
  }) {
    final priceValue = _parsePrice(price);
    final bool isDisabled = selectedTicketType != null &&
        selectedTicketType != ticketKey &&
        quantity == 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDisabled ? Colors.grey.shade300 : Colors.grey.shade200
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDisabled ? 0.02 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDisabled ? Colors.grey.shade500 : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildQuantitySelector(
                  quantity: quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                  ticketKey: ticketKey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${priceValue.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDisabled ? Colors.grey.shade400 : const Color(0xFFFC6E30),
                  ),
                ),
                if (isLimited && limit > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(isDisabled ? 0.05 : 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$limit left',
                      style: TextStyle(
                        color: isDisabled ? Colors.grey.shade400 : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            if (description != null && description != 'null')
              ExpandableText(
                text: description,
                wordLimit: 5,
                isDisabled: isDisabled,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector({
    required int quantity,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required String ticketKey,
  }) {
    final bool isDisabled = selectedTicketType != null &&
        selectedTicketType != ticketKey &&
        quantity == 0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          InkWell(
            onTap: quantity > 0 ? onDecrement : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: quantity > 0 ? const Color(0xFFE54B4D) : Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Icon(
                Icons.remove,
                color: quantity > 0 ? Colors.white : Colors.grey.shade600,
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
              color: isDisabled ? Colors.grey.shade100 : Colors.white,
            ),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDisabled ? Colors.grey.shade400 : Colors.black,
              ),
            ),
          ),
          // Increase button
          InkWell(
            onTap: isDisabled ? null : onIncrement,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDisabled ? Colors.grey.shade300 : const Color(0xFFE54B4D),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Icon(
                Icons.add,
                color: isDisabled ? Colors.grey.shade500 : Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  int _getTotalSelectedTickets() {
    return selectedTickets.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _handleBookNow() {
    final selectedTicketsList = <Map<String, dynamic>>[];

    try {
      for (var ticket in ticketController.tickets) {
        if (ticket['price'] == 'variation_wise') {
          final variations = ticket['variation_name'] as List<dynamic>? ?? [];
          final prices = ticket['variation_price'] as List<dynamic>? ?? [];

          for (int i = 0; i < variations.length; i++) {
            final ticketKey = '${ticket['_id']}_${variations[i]}';
            final quantity = selectedTickets[ticketKey] ?? 0;
            if (quantity > 0 && i < prices.length) {
              selectedTicketsList.add({
                'ticketId': ticket['_id'].toString(),
                'ticketName': ticket['ticket_name']?.toString() ?? '',
                'quantity': quantity,
                'price': prices[i].toString(),
                'totalPrice': _parsePrice(prices[i]) * quantity,
                'eventId': widget.eventId,
                'eventDate': widget.selectedDateTime?.toString() ?? '', // Added eventDate here too
              });
            }
          }
        } else {
          final quantity = selectedTickets[ticket['_id']] ?? 0;
          if (quantity > 0) {
            final price = _parsePrice(ticket['without_variation_price']);
            selectedTicketsList.add({
              'ticketId': ticket['_id'].toString(),
              'ticketName': ticket['ticket_name']?.toString() ?? '',
              'quantity': quantity,
              'price': ticket['without_variation_price']?.toString() ?? '0',
              'totalPrice': price * quantity,
              'eventId': widget.eventId,
              'eventDate': widget.selectedDateTime?.toString() ?? '',
            });
          }
        }
      }

      if (selectedTicketsList.isNotEmpty) {
        print('Selected Tickets: $selectedTicketsList');
        print('Total Price: $totalPrice');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketConfirmationScreen(
              ticketData: selectedTicketsList, // Pass the actual list, not toString()
              totalPrice: totalPrice, // Pass the total price if needed
              eventId: widget.eventId,
              eventDate: widget.selectedDateTime?.toString() ?? '',
              eventTitle:ticketController.event['event_title'].toString(),
              eventAddress:ticketController.event['address'].toString(),
            ),
          ),
        );
      } else {
        Get.snackbar('Error', 'Please select at least one ticket');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to process booking: ${e.toString()}');
    }
  }
  // ... (previous code remains the same)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (ticketController.isLoading.value) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading tickets...'),
                ],
              ),
            ),
          );
        }

        if (!isInitialized) {
          _initializeSelectedQuantities();
        }

        // Calculate if any tickets are selected (free or paid)
        final hasSelectedTickets = _getTotalSelectedTickets() > 0;

        return Stack(
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
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticketController.event['event_title']?.toString() ?? 'No title',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFFE54B4D),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _formatDateTime(widget.selectedDateTime),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFFE54B4D),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      ticketController.event["address"]?.toString() ?? 'No address',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Ticket Options List
                        if (ticketController.tickets.isNotEmpty) ...[
                          ...ticketController.tickets.map<Widget>((ticket) {
                            return _buildTicketCard(ticket as Map<String, dynamic>);
                          }).toList(),
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.confirmation_number_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No tickets available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total (${_getTotalSelectedTickets()} tickets)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '₹${totalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: totalPrice > 0 ? const Color(0xFFFC6E30) : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: hasSelectedTickets ? _handleBookNow : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasSelectedTickets
                              ? const Color(0xFFE54B4D)
                              : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: hasSelectedTickets ? 2 : 0,
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
            ),
          ],
        );
      }),
    );
  }

}


class ExpandableText extends StatefulWidget {
  final String text;
  final int wordLimit;
  final bool isDisabled;

  const ExpandableText({
    Key? key,
    required this.text,
    this.wordLimit = 10,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Split text into words
    final words = widget.text.split(" ");

    // Check if text is longer than wordLimit
    final isLongText = words.length > widget.wordLimit;

    // Short text (only first 10 words)
    final shortText = words.take(widget.wordLimit).join(" ") + (isLongText ? "..." : "");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded ? widget.text : shortText,
          style: TextStyle(
            fontSize: 14,
            color: widget.isDisabled ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        if (isLongText)
          GestureDetector(
            onTap: widget.isDisabled ? null : () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "less" : "more",
              style: TextStyle(
                fontSize: 14,
                color: widget.isDisabled ? Colors.grey[400] : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}