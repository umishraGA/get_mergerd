import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/common_controller.dart';
import '../controller/profile_controller.dart';
import '../controller/update_profile.dart';

class ModernEditProfileScreen extends StatefulWidget {
  const ModernEditProfileScreen({super.key});

  @override
  State<ModernEditProfileScreen> createState() =>
      _ModernEditProfileScreenState();
}

class _ModernEditProfileScreenState extends State<ModernEditProfileScreen> {
  final UserDetailsController userController =
      Get.put(UserDetailsController());
  final CommonDropdownController dropdownController =
      Get.put(CommonDropdownController());
  final UpdateProfileController updateController =
      Get.put(UpdateProfileController());

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;

  XFile? _selectedImage;
  String selectedInterest = '';
  String selectedOccupation = '';
  String selectedGender = '';
  String selectedMarital = '';
  String? _selectedInterestId;
  String? _selectedOccupationId;
  String? _selectedGenderId;
  String? _selectedMaritalId;

  @override
  void initState() {
    super.initState();

    // Initialize with empty values first
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();

    // Wait for the controller to load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userController.userData.value is Map<String, dynamic>) {
        final user = userController.userData.value as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = user['firstName']?.toString() ?? '';
          _lastNameController.text = user['lastName']?.toString() ?? '';
          _emailController.text = user['email']?.toString() ?? '';
          _phoneController.text = user['phone']?.toString() ?? '';
          _dobController.text = user['dob']?.toString() ?? '';

          // Set initial values for dropdowns
          if (user['interest'] is Map<String, dynamic>) {
            selectedInterest = user['interest']['name']?.toString() ?? '';
            _selectedInterestId = user['interest']['_id']?.toString();
          }

          if (user['occupation'] is Map<String, dynamic>) {
            selectedOccupation = user['occupation']['name']?.toString() ?? '';
            _selectedOccupationId = user['occupation']['_id']?.toString();
          }

          if (user['gender'] is Map<String, dynamic>) {
            selectedGender = user['gender']['name']?.toString() ?? '';
            _selectedGenderId = user['gender']['_id']?.toString();
          }

          if (user['maritalStatus'] is Map<String, dynamic>) {
            selectedMarital = user['maritalStatus']['name']?.toString() ?? '';
            _selectedMaritalId = user['maritalStatus']['_id']?.toString();
          }
        });
      }
    });
  }

  // Helper method to convert RxList to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _convertRxListToList(RxList<dynamic> rxList) {
    return rxList.map((item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else if (item is String) {
        // Handle case where items might be strings
        return {'_id': item, 'name': item};
      }
      return <String, dynamic>{};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Edit Profile "),
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Safely access user data
        final user = userController.userData.value is Map<String, dynamic>
            ? userController.userData.value as Map<String, dynamic>
            : <String, dynamic>{};

        // Convert RxList to regular List for dropdowns
        final interests = _convertRxListToList(dropdownController.interests);
        final occupations =
            _convertRxListToList(dropdownController.occupations);
        final genders = _convertRxListToList(dropdownController.genders);
        final maritalStatuses =
            _convertRxListToList(dropdownController.maritalStatuses);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPhotoSection(user),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Personal Information'),
                      const SizedBox(height: 16),
                      _buildModernTextField('First Name', _firstNameController,
                          Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildModernTextField('Last Name', _lastNameController,
                          Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                          'Email', _emailController, Icons.email_outlined),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                          'Phone', _phoneController, Icons.phone_outlined),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                          "Date of Birth", _dobController, Icons.calendar_today,
                          isDate: true),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Additional Details'),
                      const SizedBox(height: 16),
                      _buildBottomSheetSelector(
                        'Interest',
                        selectedInterest,
                        interests,
                        'Select Interest',
                        (id, name) {
                          setState(() {
                            selectedInterest = name;
                            _selectedInterestId = id;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildBottomSheetSelector(
                        'Occupation',
                        selectedOccupation,
                        occupations,
                        'Select Occupation',
                        (id, name) {
                          setState(() {
                            selectedOccupation = name;
                            _selectedOccupationId = id;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildBottomSheetSelector(
                        'Gender',
                        selectedGender,
                        genders,
                        'Select Gender',
                        (id, name) {
                          setState(() {
                            selectedGender = name;
                            _selectedGenderId = id;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildBottomSheetSelector(
                        'Marital Status',
                        selectedMarital,
                        maritalStatuses,
                        'Select Marital Status',
                        (id, name) {
                          setState(() {
                            selectedMarital = name;
                            _selectedMaritalId = id;
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildPhotoSection(Map<String, dynamic> user) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: _showImagePicker,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.purple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: _selectedImage != null
                          ? Image.file(File(_selectedImage!.path),
                              fit: BoxFit.cover)
                          : (user['image'] != null &&
                                  user['image'].toString().isNotEmpty
                              ? Image.network(user['image'].toString(),
                                  fit: BoxFit.cover)
                              : const Icon(Icons.person,
                                  size: 50, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
              // Camera icon on border
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isDate = false, // extra flag for date fields
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: isDate, // prevent typing if it's a date
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: (value) =>
            value?.isEmpty ?? true ? '$label is required' : null,

        // 👇 Show Date Picker if it's a DOB field
        onTap: isDate
            ? () async {
                FocusScope.of(context)
                    .requestFocus(FocusNode()); // close keyboard
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  controller.text =
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                }
              }
            : null,
      ),
    );
  }

  Widget _buildBottomSheetSelector(
    String label,
    String selectedValue,
    List<Map<String, dynamic>> items,
    String placeholder,
    Function(String id, String name) onSelected,
  ) {
    return GestureDetector(
      onTap: () => _showBottomSheet(label, items, onSelected),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.keyboard_arrow_down,
                  color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedValue.isEmpty ? placeholder : selectedValue,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: selectedValue.isEmpty
                          ? Colors.grey[400]
                          : Colors.black87,
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

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.purple.shade600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _saveProfile,
            child: const Center(
              child: Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(
    String title,
    List<Map<String, dynamic>> items,
    Function(String id, String name) onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    'Select $title',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            ...items
                .map((item) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.check_circle_outline,
                            color: Colors.blue),
                      ),
                      title: Text(
                        item['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        onSelected(item['_id']?.toString() ?? '',
                            item['name']?.toString() ?? '');
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildImageOption(Icons.camera_alt, 'Take Photo', () async {
                Navigator.pop(context);
                final image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) setState(() => _selectedImage = image);
              }),
              _buildImageOption(Icons.photo_library, 'Choose from Gallery',
                  () async {
                Navigator.pop(context);
                final image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) setState(() => _selectedImage = image);
              }),
              _buildImageOption(Icons.delete_outline, 'Remove Photo', () {
                Navigator.pop(context);
                setState(() => _selectedImage = null);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Prepare updated data
      Map<String, dynamic> updatedData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'dob': _dobController.text,
        'interestId': _selectedInterestId,
        'interestName': selectedInterest,
        'occupationId': _selectedOccupationId,
        'occupationName': selectedOccupation,
        'genderId': _selectedGenderId,
        'genderName': selectedGender,
        'maritalStatusId': _selectedMaritalId,
        'maritalStatusName': selectedMarital,
        'image': _selectedImage != null
            ? _selectedImage!.path // local file selected
            : (userController.userData['image'] ?? ''), // fallback to old URL
      };

      print("======= Updated Profile Data =======");
      updatedData.forEach((key, value) {
        print("$key : $value");
      });
      print("===================================");

      // ✅ Pass dropdown IDs directly to controller
      updateController.updateUserProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        image: updatedData['image'].toString(),
        maritalStatus: _selectedMaritalId.toString(),   // pass ID, not name
        interest: _selectedInterestId.toString(),       // pass ID
        gender: _selectedGenderId.toString(),           // pass ID
        occupation: _selectedOccupationId.toString(),   // pass ID
        dateOfBirth: _dobController.text,
        context: context,
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
