import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/profile/screens/interest_preferences_screen.dart';

class MemberInformationScreen extends StatefulWidget {
  static const String routeName = '/member-information';

  const MemberInformationScreen({super.key});

  @override
  State<MemberInformationScreen> createState() =>
      _MemberInformationScreenState();
}

class _MemberInformationScreenState extends State<MemberInformationScreen> {
  // User data - normally would come from a repository or service
  final Map<String, dynamic> userData = {
    'photo': null, // Will store the XFile returned from image_picker
    'name': 'Mr. Sanjay Kumar Rawat',
    'mobile': '9854785965',
    'mobile_verified': true,
    'email': 'rajeshk@gmail.com',
    'email_verified': false,
    'dob': '15-Jan-1957',
    'marital_status': 'Unmarried',
    'occupation': 'Student',
  };

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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Info Section Header
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

              // Personal Info Card
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
                      onTap: () => _editProfilePhoto(context),
                      child: _buildInfoItem(
                        title: 'Photo',
                        trailing: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: userData['photo'] != null
                                  ? FileImage(
                                      File((userData['photo'] as XFile).path))
                                  : null,
                              child: userData['photo'] == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 24,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Name
                    InkWell(
                      onTap: () => _editTextField(context, 'name', 'Name'),
                      child: _buildInfoItem(
                        title: 'Name',
                        value: userData['name'] as String,
                      ),
                    ),

                    // Mobile
                    InkWell(
                      onTap: () =>
                          _editTextField(context, 'mobile', 'Mobile Number'),
                      child: _buildInfoItem(
                        title: 'Mobile',
                        trailing: Row(
                          children: [
                            Text(
                              userData['mobile'] as String,
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
                                color: (userData['mobile_verified'] as bool)
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (userData['mobile_verified'] as bool)
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
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Email
                    InkWell(
                      onTap: () =>
                          _editTextField(context, 'email', 'Email Address'),
                      child: _buildInfoItem(
                        title: 'Email',
                        trailing: Row(
                          children: [
                            Text(
                              userData['email'] as String,
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
                                color: (userData['email_verified'] as bool)
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (userData['email_verified'] as bool)
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
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Date of Birth
                    InkWell(
                      onTap: () => _editDateField(context),
                      child: _buildInfoItem(
                        title: 'Date of Birth',
                        value: userData['dob'] as String,
                      ),
                    ),

                    // Marital Status
                    InkWell(
                      onTap: () => _editDropdownField(
                          context,
                          'marital_status',
                          'Marital Status',
                          ['Unmarried', 'Married', 'Divorced', 'Widowed']),
                      child: _buildInfoItem(
                        title: 'Marital Status',
                        value: userData['marital_status'] as String,
                      ),
                    ),

                    // Occupation
                    InkWell(
                      onTap: () => _editDropdownField(
                          context, 'occupation', 'Occupation', [
                        'Student',
                        'Employed',
                        'Self-employed',
                        'Business',
                        'Retired',
                        'Homemaker'
                      ]),
                      child: _buildInfoItem(
                        title: 'Occupation',
                        value: userData['occupation'] as String,
                      ),
                    ),

                    // Interest Preferences
                    InkWell(
                      onTap: () => _navigateToInterestPreferences(context),
                      child: _buildInfoItem(
                        title: 'Interest Preferences',
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Take a photo using camera
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          userData['photo'] = photo;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo updated')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          userData['photo'] = image;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo updated')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Edit profile photo
  void _editProfilePhoto(BuildContext context) {
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
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              if (userData['photo'] != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove photo',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      userData['photo'] = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photo removed')),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Edit text fields (name, mobile, email)
  void _editTextField(BuildContext context, String field, String label) {
    final TextEditingController controller =
        TextEditingController(text: userData[field] as String);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  userData[field] = controller.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label updated')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Edit date field
  void _editDateField(BuildContext context) async {
    // Parse current date
    final List<String> dateParts = (userData['dob'] as String).split('-');
    final String day = dateParts[0];

    // Convert month name to number (simplified)
    final Map<String, int> monthMap = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };

    final int month = monthMap[dateParts[1]] ?? 1;
    final int year = int.parse(dateParts[2]);

    final DateTime initialDate = DateTime(year, month, int.parse(day));
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      // Convert month number to abbreviated name
      final List<String> monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      setState(() {
        userData['dob'] =
            '${picked.day.toString().padLeft(2, '0')}-${monthNames[picked.month - 1]}-${picked.year}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date of Birth updated')),
      );
    }
  }

  // Edit dropdown fields (marital status, occupation)
  void _editDropdownField(
      BuildContext context, String field, String label, List<String> options) {
    String selectedValue = userData[field] as String;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Select $label'),
            content: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedValue = newValue;
                  });
                }
              },
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  this.setState(() {
                    userData[field] = selectedValue;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$label updated')),
                  );
                },
              ),
            ],
          );
        });
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

    // Handle result if needed
    if (result != null && result is List<String>) {
      // You could save these preferences or show a confirmation
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
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
