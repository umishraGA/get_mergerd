import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/listings/widgets/ClinicCard.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Jointech focuses on the AIoT and big data applications of smart logistics, and is committed to becoming a leading global provider and operator of mobile asset management solutions,',
              style: AppTextStyles.medium14,
            ),
          ),
          _buildInfoItem('Company CEO', 'Ankit Agarwal'),
          _buildInfoItem('Year of Establishment', '2025'),
          _buildInfoItem('Nature of Business', 'Distributor'),
          _buildInfoItem('Business GSTIN Number', '09CYIPA3300H1ZV'),
          _buildInfoItem('GST Legal Status', 'Private Limited Company'),
          _buildInfoItem('Business GST Turnover', '10 L- 50 L'),
          _buildInfoItem('Business Timings', '10 L- 50 L'),
          _buildInfoItem('Number of Employees', 'Upto 10'),
          _buildInfoItem(
              'Payment Mode', 'Debit Card, Credit Card, UPI, IMPS, RTGS'),
          _buildInfoItem('Banker Name', 'State Bank of India'),
          _buildInfoItem(
            'Business Website',
            'http://www.jivaayurvedicclinic.com/',
            isLink: true,
          ),
          const Divider(
            color: Colors.grey,
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'More Businesses Like This',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 24,
          ),
          const ClinicCard(),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.medium14.copyWith(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.medium14.copyWith(
              color: isLink ? Colors.blue : Colors.black,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }
}
