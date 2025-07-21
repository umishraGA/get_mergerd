import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';

class DonationPage extends StatelessWidget {
  final String? imagePath;

  const DonationPage({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Temple image at the top
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath ?? 'assets/images/spiritual/temple_donation.jpg',
              width: double.infinity,
              height: isTablet ? 360 : 200,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 24),

          // Donation options text
          const Text(
            'There are several options to make a donation to Shree Siddhivinayak Ganapati Temple(Prabhadevi) Trust like Cheques & Demand Drafts, Cash Cards, Credit Cards, Debit Cards and Internet Banking (Net Banking).',
            style: AppTextStyles.medium15,
          ),

          const SizedBox(height: 20),

          // Cash donation instructions
          const Text(
            'Please deposit Cash in the Hundis which have been kept all over the Temple premises or pay them at the Pooja Booking Counter inside the temple premises or at the Accounts Office (Donation Dept) on the 4th Floor. Do not hand over cash to any person. Cheques, Demand Drafts and Pay Orders in ANY CURRENCY have to be made in favour of Shree Siddhivinayak Ganapati Temple Trust and handed over at the Pooja Booking Counter inside the temple premises or at the Accounts Office (Donation Dept) on the 4th Floor. The Office will issue a donation receipt.',
            style: AppTextStyles.medium15,
          ),

          const SizedBox(height: 24),

          // DOMESTIC DONATIONS heading
          const Text(
            'DOMESTIC DONATIONS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          // Bank details table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildBankDetailRow('Bank Name', 'Indian Bank'),
                _buildDivider(),
                _buildBankDetailRow('Branch', 'Prabhadevi'),
                _buildDivider(),
                _buildBankDetailRow('Account Number', '409578126'),
                _buildDivider(),
                _buildBankDetailRow('IFSC Code', 'IDIB000P079'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Online donation text
          const Text(
            'You can make a donation to Shree Siddhivinayak Ganapati Temple Trust using your Cash Card or Credit and Debit Card as well as your Internet Banking Accounts (Netbanking) on this website.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),

          // Donate Now button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE05757),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Donate Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const CommonDivider();
  }
}
