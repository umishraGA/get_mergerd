import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/listings/views/VendorDetailsPage.dart';
import 'package:myapp/features/listings/widgets/RatingItem.dart';

import '../views/vendor_list_page.dart';

class ClinicCard extends StatelessWidget {
  final bool isHighlighted;

  const ClinicCard({
    super.key,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 7, // Show 3 items for demo
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildClinicCard(context,
          isHighlighted: index == 0 ? isHighlighted : false),
    );
  }

  Widget _buildClinicCard(BuildContext context, {bool isHighlighted = false}) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>  Vendordetailspage()),
        // );
      },
      child: Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFFFFDE7) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Clinic info card

            Column(
              children: [
                // Top section with image and details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Clinic image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/listings/items/food_image.png',
                        width: 112,
                        height: 148,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Details section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Clinic name and verification
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Jiva Ayurvedic Clinic',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified,
                                color: Colors.green[600],
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Location
                          const Text(
                            'Sector 18, Noida, 1.8 km',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF909090),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Rating and reviews row
                          const RatingItem(),
                          const SizedBox(height: 8),

                          // Opening hours
                          Row(
                            children: [
                              Text(
                                'Opens',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Closes 09:30 PM',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(top: 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF371f66),
                                  Color(0xFF371f66),
                                  Color(0xFFFFFFFF)
                                ],
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.local_offer_outlined,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '5+ offers on Utsav',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action buttons
              ],
            ),
          // call , Enquiry, direction
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F9D58),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call, size: 16),
                        SizedBox(width: 8),
                        Text('Call'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const EnquiryPage(
                      //             clinicName: 'Jiva Ayurvedic Clinic',
                      //             category: 'Ayurvedic',
                      //             subCategory: 'Clinic',
                      //           )),
                      // );

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBC02D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: const Text('Enquiry'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4976C2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions, size: 16),
                        SizedBox(width: 8),
                        Text('Direction'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Utsav offers banner

            const SizedBox(height: 10),
            const CommonDivider(),
          ],
        ),
      ),
    );
  }
}
