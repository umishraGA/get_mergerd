import 'package:flutter/material.dart';
import '../../../../core/theme/AppTextStyles.dart';
import '../../../common/widgets/CommonDivider.dart';
import 'temple_detail_screen.dart'; // Make sure this path is correct

class TempleListingWidget extends StatefulWidget {
  const TempleListingWidget({super.key});

  @override
  State<TempleListingWidget> createState() => _TempleListingWidgetState();
}

class _TempleListingWidgetState extends State<TempleListingWidget> {
  final List<bool> _expandedDescriptions = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Change this based on how many listings you have
      itemBuilder: (context, index) {
        return _buildTempleListing(context, index);
      },
    );
  }

  Widget _buildTempleListing(BuildContext context, int index) {
    const String fullDescription =
        'A huge building has been constructed for satsang in the temple, in which 25000 people can sit together. The walls temple, in which 25000 people together. The walls of the temple are adorned with beautiful carvings depicting scenes from the Ramayana. The temple is a symbol of faith and devotion for millions of Hindus around the world. The grand structure features intricate architecture that blends traditional temple styles with modern engineering techniques. Visitors can explore the main sanctum, prayer halls, and surrounding gardens during visiting hours. Special ceremonies and rituals are performed during festivals and auspicious occasions.';

    final isTablet = MediaQuery.of(context).size.width > 600;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TempleDetailScreen(
              templeId: "temple['_id'] as String,"

            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temple image
                Container(
                  height: isTablet ? 360 : 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/spiritual/ayodhya_temple.png',
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 12),

                // Temple info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Temple name and location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ayodhya',
                              style: AppTextStyles.bold16.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          'Uttar Pradesh',
                          style: AppTextStyles.medium14.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Followers count
                    Text(
                      '10.1k Followers',
                      style: AppTextStyles.medium15.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Temple description
                Text(
                  fullDescription,
                  style: AppTextStyles.medium15.copyWith(
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: _expandedDescriptions[index] ? null : 3,
                  overflow: _expandedDescriptions[index]
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // More/Less toggle
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedDescriptions[index] =
                      !_expandedDescriptions[index];
                    });
                  },
                  child: Text(
                    _expandedDescriptions[index] ? 'less' : 'more',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CommonDivider(),
          ),
        ],
      ),
    );
  }
}
