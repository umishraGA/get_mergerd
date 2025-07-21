import 'package:flutter/material.dart';
import 'package:myapp/common/navigation/route_manager.dart';
import 'package:myapp/features/profile/screens/interest_preferences_screen.dart';
import 'package:myapp/features/profile/screens/my_followings_screen.dart';
import 'package:myapp/features/profile/screens/refer_earn_screen.dart';
import 'package:myapp/features/profile/screens/saved_posts_screen.dart';
import 'package:myapp/features/profile/screens/your_tickets_screen.dart';
import 'package:myapp/features/profile/widgets/profile_header.dart';
import 'package:myapp/features/profile/widgets/profile_menu_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            GestureDetector(
              onTap: () => _navigateToMemberInformation(context),
              child: const ProfileHeader(
                name: 'Sanjay Kumar Rawat',
                phone: '9856985874',
                isVerified: true,
              ),
            ),

            // Silver Buyer Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5E9C9), Color(0xFFEFD9A0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: Color(0xFF8B6E3B),
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Silver Buyer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B6E3B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Suppliers want to know more about you.',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF8B6E3B).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Complete Profile Banner
            GestureDetector(
              onTap: () => _navigateToMemberInformation(context),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B6E3B), Color(0xFF9F815B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Complete your profile to be more trustable.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Go',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Subscription Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 62,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5945AB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  padding: EdgeInsets.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Flexible(
                              child: Text(
                                'Get Utsav Subscription',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Utsav Section
            Container(
              margin: const EdgeInsets.only(left: 16, top: 8, bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Utsav',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            buildMenuSection([
              ProfileMenuItem(
                title: 'My Membership',
                icon: Icons.chevron_right,
                onTap: () => _navigateToMyMembership(context),
              ),
              ProfileMenuItem(
                title: 'My Vouchers',
                icon: Icons.chevron_right,
                onTap: () => _navigateToMyVouchers(context),
              ),
            ]),

            // Events Section
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16, bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Events',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            buildMenuSection([
              ProfileMenuItem(
                title: 'Your Tickets',
                icon: Icons.chevron_right,
                onTap: () => _navigateToYourTickets(context),
              ),
            ]),

            // Quiz Section
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16, bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Quiz',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            buildMenuSection([
              ProfileMenuItem(
                title: 'My Points',
                icon: Icons.chevron_right,
                onTap: () => _navigateToMyPoints(context),
              ),
            ]),

            // Spiritual Section
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16, bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Spiritual',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            buildMenuSection([
              ProfileMenuItem(
                title: 'Following',
                icon: Icons.chevron_right,
                onTap: () => _navigateToFollowings(context),
              ),
            ]),

            // Business and Saved Posts
            buildMenuSection([
              ProfileMenuItem(
                title: 'List Your Business',
                icon: Icons.chevron_right,
                onTap: () => _navigateToListBusiness(context),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              ProfileMenuItem(
                title: 'Saved Posts',
                icon: Icons.chevron_right,
                onTap: () => _navigateToSavedPosts(context),
              ),
              ProfileMenuItem(
                title: 'My Following Business',
                icon: Icons.chevron_right,
                onTap: () => _navigateToMyFollowingBusiness(context),
              ),
              ProfileMenuItem(
                title: 'Refer & Earn',
                icon: Icons.chevron_right,
                onTap: () => _navigateToReferEarn(context),
              ),
              ProfileMenuItem(
                title: 'Notifications',
                icon: Icons.chevron_right,
                onTap: () => _navigateToNotifications(context),
              ),
              ProfileMenuItem(
                title: 'App Update Available',
                icon: Icons.chevron_right,
                onTap: () => _navigateToAppUpdate(context),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'v1.2.5.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ]),

            // More section
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16, bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'More',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            buildMenuSection([
              ProfileMenuItem(
                title: 'Interest Preferences',
                icon: Icons.chevron_right,
                onTap: () => _navigateToInterestPreferences(context),
              ),
              ProfileMenuItem(
                title: 'FAQs',
                icon: Icons.chevron_right,
                onTap: () => _navigateToFAQs(context),
              ),
              ProfileMenuItem(
                title: 'Privacy Policy',
                icon: Icons.chevron_right,
                onTap: () => _navigateToPrivacyPolicy(context),
              ),
              ProfileMenuItem(
                title: 'Terms & Conditions',
                icon: Icons.chevron_right,
                onTap: () => _navigateToTermsConditions(context),
              ),
              ProfileMenuItem(
                title: 'Customer Support',
                icon: Icons.chevron_right,
                onTap: () => _navigateToCustomerSupport(context),
              ),
              ProfileMenuItem(
                title: 'Log Out',
                icon: Icons.chevron_right,
                onTap: () => _showLogoutDialog(context),
              ),
            ]),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: const Text(
                'Happening Bazaar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMemberInformation(BuildContext context) {
    Navigator.pushNamed(context, RouteManager.memberInformationPage);
  }

  void _navigateToInterestPreferences(BuildContext context) async {
    // Navigate to the Interest Preferences screen directly without using named routes
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const InterestPreferencesScreen()));

    // Handle the result if needed
    if (result != null && result is List<String>) {
      // Do something with the selected industries
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated interests: ${result.join(", ")}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToReferEarn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReferEarnScreen()),
    );
  }

  void _navigateToYourTickets(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const YourTicketsScreen()),
    );
  }

  void _navigateToFollowings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyFollowingsScreen()),
    );
  }

  void _navigateToSavedPosts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedPostsScreen()),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add logout functionality here
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToMyMembership(BuildContext context) {
    // Create dedicated screen in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('My Membership feature coming soon')),
    );
  }

  void _navigateToMyVouchers(BuildContext context) {
    // Create dedicated screen in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('My Vouchers feature coming soon')),
    );
  }

  void _navigateToMyPoints(BuildContext context) {
    // Create dedicated screen in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('My Points feature coming soon')),
    );
  }

  void _navigateToListBusiness(BuildContext context) {
    // Create dedicated screen in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('List Your Business feature coming soon')),
    );
  }

  void _navigateToMyFollowingBusiness(BuildContext context) {
    // Create dedicated screen in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('My Following Business feature coming soon')),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    // Create dedicated screen in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications feature coming soon')),
    );
  }

  void _navigateToAppUpdate(BuildContext context) {
    // Handle app update logic in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App update feature coming soon')),
    );
  }

  void _navigateToFAQs(BuildContext context) {
    _launchURL('https://example.com/faqs');
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    _launchURL('https://example.com/privacy-policy');
  }

  void _navigateToTermsConditions(BuildContext context) {
    _launchURL('https://example.com/terms-and-conditions');
  }

  void _navigateToCustomerSupport(BuildContext context) {
    // Create dedicated screen in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer Support feature coming soon')),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }

  Widget buildMenuSection(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }
}
