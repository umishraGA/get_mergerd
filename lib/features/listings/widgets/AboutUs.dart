import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/listings/widgets/VendorCard.dart';
import 'package:url_launcher/url_launcher.dart';

class Aboutus extends StatelessWidget {
  final String aboutText;
  final Map<String, dynamic> companyInfo;
  final Map<String, dynamic> contactInfo;
  final Map<String, dynamic> locationInfo;

  const Aboutus({
    super.key,
    required this.aboutText,
    required this.companyInfo,
    required this.contactInfo,
    required this.locationInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              aboutText.isNotEmpty ? aboutText : 'No description available',
              style: AppTextStyles.medium14,
            ),
          ),
          _buildInfoItem('Company CEO', companyInfo['companyCeo']?.toString() ?? 'Not available'),
          _buildInfoItem('Year of Establishment', companyInfo['establishYear']?.toString() ?? 'Not available'),
          _buildInfoItem('Nature of Business', companyInfo['businessNature']?['name']?.toString() ?? 'Not available'),
          _buildInfoItem('Business Category', companyInfo['businessCategory']?['name']?.toString() ?? 'Not available'),
          _buildInfoItem('GST Legal Status', companyInfo['businessLegal']?['name']?.toString() ?? 'Not available'),
          _buildInfoItem('Business GST Turnover', companyInfo['gstTurnOver']?.toString() ?? 'Not available'),
          _buildInfoItem('Number of Employees', companyInfo['employeeNumber']?['name']?.toString() ?? 'Not available'),
          _buildPaymentModesItem(),
          _buildInfoItem('Banker Name', companyInfo['bankerName']?['name']?.toString() ?? 'Not available'),
          _buildInfoItem(
            'Business Website',
            companyInfo['companyWebsite']?.toString() ?? 'Not available',
            isLink: companyInfo['companyWebsite']?.toString().isNotEmpty ?? false,
          ),
          _buildContactInfoItem('Phone', contactInfo['phoneNo']?.toString()),
          _buildContactInfoItem('Alternate Phone', contactInfo['alternateNo']?.toString()),
          _buildContactInfoItem('Email', contactInfo['email']?.toString(), isEmail: true),
          _buildContactInfoItem('Toll Free', contactInfo['tollFreeNumber']?.toString()),
          _buildContactInfoItem('Office Landline', contactInfo['officeLandline']?.toString()),
          _buildContactInfoItem('Home Landline', contactInfo['homeLandline']?.toString()),
          _buildLocationInfo(),
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
    if (value == 'Not available' || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.medium14.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: isLink ? () {
              final url = value.startsWith('http') ? value : 'https://$value';
              launchUrl(Uri.parse(url));
            } : null,
            child: Text(
              value,
              style: AppTextStyles.medium14.copyWith(
                color: isLink ? Colors.blue : Colors.black54,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoItem(String label, String? value, {bool isEmail = false}) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.medium14.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              if (isEmail) {
                launchUrl(Uri.parse('mailto:$value'));
              } else {
                launchUrl(Uri.parse('tel:$value'));
              }
            },
            child: Text(
              value,
              style: AppTextStyles.medium14.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentModesItem() {
    final paymentOptions = companyInfo['paymentOptions'] as List<dynamic>?;
    if (paymentOptions == null || paymentOptions.isEmpty) return const SizedBox.shrink();

    final paymentModes = paymentOptions.map((option) {
      // Convert to title case
      if (option is String) {
        return option[0].toUpperCase() + option.substring(1);
      }
      return option.toString();
    }).join(', ');

    return _buildInfoItem('Payment Modes', paymentModes);
  }

  Widget _buildLocationInfo() {
    final country = locationInfo['country']?.toString() ?? '';
    final state = locationInfo['state']?.toString() ?? '';
    final city = locationInfo['city']?.toString() ?? '';
    final area = locationInfo['area']?.toString() ?? '';
    final pincode = locationInfo['pincode']?.toString() ?? '';
    final address = locationInfo['address']?.toString() ?? '';

    if (address.isEmpty && country.isEmpty) return const SizedBox.shrink();

    String locationText = address;
    if (locationText.isEmpty) {
      locationText = [area, city, state, country, pincode]
          .where((part) => part.isNotEmpty)
          .join(', ');
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: AppTextStyles.medium14.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            locationText,
            style: AppTextStyles.medium14.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}