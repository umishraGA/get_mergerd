import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';

import '../models/event_model.dart';

class EventDetailCard extends StatefulWidget {
  final Event event;
  final VoidCallback? onBookPressed;

  const EventDetailCard({
    super.key,
    required this.event,
    this.onBookPressed,
  });

  @override
  State<EventDetailCard> createState() => _EventDetailCardState();
}

class _EventDetailCardState extends State<EventDetailCard> {
  @override
  Widget build(BuildContext context) {

    final isTablet = MediaQuery.of(context).size.width > 600;
    return LayoutBuilder(
      builder: (context, constraints) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image with category label
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.event.imagePath,
                    height: isTablet ? 360 : 184,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: isTablet ? 360 : 184,
                        color: Colors.grey[800],
                        width: double.infinity,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: constraints.maxWidth * 0.9,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.56),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.event.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Event title
            Text(
              widget.event.title,
              style: AppTextStyles.medium18.copyWith(
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 20),

            // Date and time with icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 28,
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat('EEE, dd MMM yyyy').format(widget.event.date)} | ${widget.event.time}',
                        style: AppTextStyles.regular14.copyWith(
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Venue and location with icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 28,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.event.venue} | ${widget.event.location}',
                        style: AppTextStyles.regular14.copyWith(
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Price and book button
            Row(
              children: [
                // Price section
                Container(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.4,
                  ),
                  child: Text(
                    '₹${widget.event.price.toInt()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFC6E30),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const Spacer(),

                // Button section
                Container(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.55,
                  ),
                  child: TextButton(
                    onPressed: widget.onBookPressed,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE54B4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(100, 30),
                    ),
                    child: const Text(
                      'Book Events',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
