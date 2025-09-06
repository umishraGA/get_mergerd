import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/profile/screens/interest_preferences_screen.dart';
import '../controller/profile_controller.dart';
import 'edit_profile.dart';

class MemberInformationScreen extends StatefulWidget {
  static const String routeName = '/member-information';

  const MemberInformationScreen({super.key});

  @override
  State<MemberInformationScreen> createState() =>
      _MemberInformationScreenState();
}

class _MemberInformationScreenState extends State<MemberInformationScreen> {
  final UserDetailsController controller = Get.put(UserDetailsController());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          'Member Information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  ModernEditProfileScreen())),
            icon: const Icon(Icons.edit, color: Colors.black, size: 20),
            label: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.userData.isEmpty) {
          return const Center(child: Text("No user data found"));
        }

        final user = controller.userData;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Row(
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
                      'Personal Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Card
                Container(
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
                  child: Column(
                    children: [
                      // Photo
                      InkWell(
                        onTap: () => _editProfilePhoto(context, user as Map<String, dynamic>),
                        child: _buildInfoItem(
                          title: 'Photo',
                          trailing: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: user['photo'] != null
                                    ? FileImage(File((user['photo'] as XFile).path))
                                as ImageProvider
                                    : (user['image'] != null &&
                                    user['image'].toString().isNotEmpty
                                    ? NetworkImage(user['image'].toString())
                                    : null),
                                child: (user['photo'] == null &&
                                    (user['image'] == null ||
                                        user['image'].toString().isEmpty))
                                    ? const Icon(Icons.person,
                                    size: 40, color: Colors.grey)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),

                      // Name
                      _buildInfoItem(
                        title: 'Name',
                        value: user['firstName']?.toString() ?? 'Unknown',
                      ),

                      // Mobile
                      _buildInfoItem(
                        title: 'Mobile',
                        trailing: Row(
                          children: [
                            Text(
                              user['phone']?.toString() ?? 'N/A',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (user['phoneVerified'] as bool?? false)
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (user['phoneVerified']as bool ?? false)
                                    ? 'Verified'
                                    : 'Unverified',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),

                      // Email
                      _buildInfoItem(
                        title: 'Email',
                        trailing: Row(
                          children: [
                            Text(
                              user['email']?.toString() ?? 'N/A',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (user['emailVerified']as bool ?? false)
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (user['emailVerified']as bool ?? false)
                                    ? 'Verified'
                                    : 'Unverified',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),

                      // DOB
                      _buildInfoItem(
                        title: 'Date of Birth',
                        value: user['dob']?.toString() ?? '--',
                      ),

                      // Marital Status
                      _buildInfoItem(
                        title: 'Marital Status',
                        value: user['maritalStatus']?['name'] ?.toString()?? '--',
                      ),

                      // Occupation
                      _buildInfoItem(
                        title: 'Occupation',
                        value: user['occupation']?['name'] ?.toString()?? '--',
                      ),

                      // Interest Preferences
                      InkWell(
                        onTap: () => _navigateToInterestPreferences(context),
                        child: _buildInfoItem(
                          title: 'Interest Preferences',
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Edit profile photo
  void _editProfilePhoto(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    // controller.updatePhoto(photo);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    // controller.updatePhoto(photo);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Navigate to Interest Preferences screen
  void _navigateToInterestPreferences(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InterestPreferencesScreen(),
      ),
    );

    if (result != null && result is List<String>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated interests: ${result.join(", ")}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildInfoItem({
    required String title,
    String? value,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            trailing ??
                Row(
                  children: [
                    Text(
                      value ?? '',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
