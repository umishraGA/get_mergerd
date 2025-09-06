import 'package:flutter/material.dart';
import 'package:myapp/features/listings/views/EnquiryPage.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class ProductDetailPage extends StatefulWidget {
  final String name;
  final String clinic;
  final String originalPrice;
  final String discountedPrice;
  final String discount;

  const ProductDetailPage({
    super.key,
    required this.name,
    required this.clinic,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discount,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  final int _imageCount = 3;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(
              title: "",
              showMenu: true,
              showDivider: false,
              // onWriteReview: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const WriteReviewPage(
              //         clinicName:
              //             'SSR Ayurvedic and Panchkarma Clinic',
              //         address:
              //             'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida ,Uttar Pradesh',
              //       ),
              //     ),
              //   );
              // },
              // onReportBusiness: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ReportIssuePage(
              //         clinicName:
              //             'SSR Ayurvedic and Panchkarma Clinic',
              //         address:
              //             'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida ,Uttar Pradesh',
              //         onReportSubmitted: () {
              //           Navigator.pop(context);
              //           _showReportSuccessNotification();
              //         },
              //       ),
              //     ),
              //   );
              // },
            ),
            // Product Image with Page Indicator
            Stack(
              children: [
                SizedBox(
                  height: isTablet ? 350 : 250,
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: _imageCount,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        'assets/images/listings/items/food_image.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _imageCount,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Clinic Name
                  Text(
                    widget.clinic,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EnquiryPage(
                                        clinicName: widget.clinic,
                                        category: widget.name,
                                        subCategory: widget.name,
                                        businessId: '',
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFBC02D),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
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

                  const SizedBox(height: 16),
                  const Divider(),

                  // Price Information
                  Row(
                    children: [
                      const Text(
                        'MRP : ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.originalPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Offer Price : ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.discountedPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Discount : ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.discount,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Available',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  // Product Description
                  const Text(
                    'Product Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(110, 48),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}
