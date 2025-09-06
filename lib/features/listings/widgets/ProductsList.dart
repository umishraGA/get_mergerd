import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/listings/views/ProductDetailPage.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  // Track expanded state for each category
  final Map<String, bool> _expandedStates = {
    'Liver Medicines': true,
    'Kidney Medicines': false,
  };

  // Add scroll controller for synchronized scrolling
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController, // Apply the scroll controller
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      children: [
        _buildCategorySection(
          'Liver Medicines',
          '15 Products',
          [
            _buildProductCard(
              name: 'Kayakalp Syrup',
              description:
                  'Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds',
              originalPrice: '₹420',
              discountedPrice: '₹620',
              discount: '20% Off',
              category: 'Liver Medicines',
            ),
            _buildProductCard(
              name: 'Kayakalp Syrup',
              description:
                  'Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds',
              originalPrice: '₹420',
              discountedPrice: '₹620',
              discount: '20% Off',
              category: 'Liver Medicines',
            ),
            _buildProductCard(
              name: 'Kayakalp Syrup',
              description:
                  'Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds',
              originalPrice: '₹420',
              discountedPrice: '₹620',
              discount: '20% Off',
              category: 'Liver Medicines',
            ),
          ],
        ),
        const CommonDivider(),
        _buildCategorySection(
          'Kidney Medicines',
          '15 Products',
          [
            _buildProductCard(
              name: 'Kayakalp Syrup',
              description:
                  'Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds',
              originalPrice: '₹420',
              discountedPrice: '₹620',
              discount: '20% Off',
              category: 'Liver Medicines',
            ),
            _buildProductCard(
              name: 'Kayakalp Syrup',
              description:
                  'Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds',
              originalPrice: '₹420',
              discountedPrice: '₹620',
              discount: '20% Off',
              category: 'Liver Medicines',
            ),
            _buildProductCard(
              name: 'Kayakalp Syrup',
              description:
                  'Lorem ipsum dolor sit amet. Lorem elitr ut tempor duo ea ssds',
              originalPrice: '₹420',
              discountedPrice: '₹620',
              discount: '20% Off',
              category: 'Liver Medicines',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    String title,
    String productCount,
    List<Widget> products,
  ) {
    // Use the title as a key to track expansion state
    bool isExpanded = _expandedStates[title] ?? false;

    return Column(
      key: ValueKey('category-$title'),
      children: [
        // Custom header with consistent background color
        Container(
          color: const Color(0xFFEEEEEE),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  productCount,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF909090),
                  ),
                ),
              ],
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            onTap: () {
              setState(() {
                _expandedStates[title] = !isExpanded;
              });
            },
          ),
        ),

        // Vertical-only animation with smoother transition
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              height: isExpanded ? null : 0,
              color: Colors.white,
              child: isExpanded
                  ? Column(children: [const SizedBox(height: 10), ...products])
                  : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String name,
    required String description,
    required String originalPrice,
    required String discountedPrice,
    required String discount,
    required String category,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Discount Tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/listings/items/food_image.png',
                  width: 115,
                  height: 135,
                  fit: BoxFit.cover,
                ),
              ),
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   child: Container(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              //     decoration: const BoxDecoration(
              //       color: Color(0xFFED3237),
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(8),
              //         bottomRight: Radius.circular(8),
              //       ),
              //     ),
              //     child: Text(
              //       discount,
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 10,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'MRP ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Color(0xFF909090),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      discountedPrice,
                      style: AppTextStyles.bold14.copyWith(
                        color: const Color(0xFFED3237),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFED3237),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Text(
                    //   "",
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              name: name,
                              clinic: 'SSR Ayurvedic and Panchkarma Clinic',
                              originalPrice: originalPrice,
                              discountedPrice: discountedPrice,
                              discount: discount,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED3237),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Get Best Price',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
