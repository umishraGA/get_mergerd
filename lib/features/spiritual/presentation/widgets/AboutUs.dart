import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About text
          const Text(
            'Jointech focuses on the AioT and big data applications of smart logistics, and is committed to becoming a leading global provider and operator of mobile asset management solutions, particularly offering global solutions for logistics equipment that carries.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // History section
          const Text(
            'History of Temple',
            style: AppTextStyles.bold18,
          ),

          const SizedBox(height: 10),

          const Text(
            'The Kaal Bhairav Temple of Ujjain was built by King Bhadrasen, which is also mentioned in the Avanti Khanda of Skanda Purana. In this temple, idols of Lord Shiva, Mother Parvati, Lord Vishnu, and Ganesha from the Parmar era (9th to 13th century) have been discovered. During Raja Bhoj\'s reign, this temple was also rebuilt at the same time.',
            style: AppTextStyles.medium15,
          ),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // Significance section
          const Text(
            'Significance of the temple',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'It is popularly believed that King Mahakal of Ujjain appointed Kalabhairav to protect the city. For this reason, Kalbhairav is also called Kotwal of the city. In this temple of Bhairav Baba, alcohol is offered to him, but where the alcohol goes, this mystery has remained a mystery today. Thousands of devotees reach here every day to see this idol of Kalabhairav drinking alcohol. In this temple, the idol of Lord Kalabhairav is seen wearing a Saindia turban. This turban comes from the Saindia family of Gwalior for Baba Bhairavnath. This practice has been going on for hundreds of years.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // Darshan time section
          const Text(
            'Darshan Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _buildTimeSection('Morning', '6:30 AM - 12:00 PM'),
          const SizedBox(height: 8),
          _buildTimeSection('Evening', '6:00 PM - 12:00 PM'),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // Aarti time section
          const Text(
            'Aarti Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _buildTimeSection('Mangala Aarti timing', '6:30 AM - 12:00 PM'),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // Address section
          const Text(
            'Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Uttar Pradesh, India',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // Google Map section
          const Text(
            'Google Map',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.directions),
            label: const Text('Get Direction'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6BD6),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // Social Media section
          const Text(
            'Social Media',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _buildSocialIcon("assets/images/spiritual/youtube_logo.png"),
              const SizedBox(width: 16),
              _buildSocialIcon("assets/images/spiritual/insta_logo.png"),
              const SizedBox(width: 16),
              _buildSocialIcon("assets/images/spiritual/facebook_logo.png"),
            ],
          ),

          const SizedBox(height: 10),
          const CommonDivider(),
          const SizedBox(height: 10),

          // Contact section
          const Text(
            'Contact',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            '9845879654, 8547895478',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTimeSection(String title, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String image) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Image.asset(
        image,
        width: 24,
        height: 24,
      ),
    );
  }
}
