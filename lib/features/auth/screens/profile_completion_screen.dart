// ... existing imports
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controller/area_controller.dart';
import '../controller/create_account_controller.dart';
import 'interest_selection_screen.dart';

class ProfileCompletionScreen extends StatefulWidget {
  final String? name;
  final String? email;
  final String? mobile;

  const ProfileCompletionScreen({
    super.key,
    this.name,
    this.email,
    this.mobile,
  });

  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final CreateAccountController createAccountController = Get.put(CreateAccountController());
  final LocationController locationController = Get.put(LocationController());

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();

  XFile? _profileImage;
  bool _isLoading = false;
  String? _selectedGenderId;
  String? _selectedCountryId;
  String? _selectedStateId;
  String? _selectedCityId;
  String? _selectedAreaId;
  String? _selectedOccupationId;
  String? _selectedMaritalStatusId;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      _nameController.text = widget.name!;
    }
    locationController.fetchCountries(context);
    locationController.fetchGenders(context);
    locationController.fetchMaritalStatus(context);
    locationController.fetchOccupations(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: options.contains(value) ? value : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            style: const TextStyle(color: Colors.black87, fontSize: 15),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF426DB3)),
            isExpanded: true,
            onChanged: options.isNotEmpty ? onChanged : null,
            items: options.isNotEmpty
                ? options.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList()
                : const [DropdownMenuItem<String>(value: null, child: Text("No Data Found"))],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Complete Your Profile',
            style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Obx(() => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Profile image
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: _profileImage != null
                              ? Image.file(File(_profileImage!.path), fit: BoxFit.cover)
                              : Icon(Icons.person, size: 60, color: Colors.grey.shade400),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF426DB3),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Name
                _buildTextField('Full Name', _nameController, Icons.person_outline),
                const SizedBox(height: 16),

                // DOB
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    hintText: 'DD/MM/YYYY',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF426DB3)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please select your date of birth' : null,
                ),
                const SizedBox(height: 16),

                // Dropdowns
                _buildDropdown(
                  label: 'Gender',
                  value: _selectedGenderId != null
                      ? locationController.genders.firstWhereOrNull((e) => e.id == _selectedGenderId)?.name
                      : null,
                  options: locationController.genders.map((e) => e.name).toList(),
                  onChanged: (val) {
                    final selected = locationController.genders.firstWhereOrNull((e) => e.name == val);
                    setState(() => _selectedGenderId = selected?.id);
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'Country',
                  value: _selectedCountryId != null
                      ? locationController.countries.firstWhereOrNull((e) => e.id == _selectedCountryId)?.name
                      : null,
                  options: locationController.countries.map((e) => e.name).toList(),
                  onChanged: (val) {
                    final selected = locationController.countries.firstWhereOrNull((e) => e.name == val);
                    setState(() {
                      _selectedCountryId = selected?.id;
                      _selectedStateId = null;
                      _selectedCityId = null;
                      _selectedAreaId = null;
                    });
                    if (selected != null) {
                      locationController.fetchStates(context, selected.id);
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'State',
                  value: _selectedStateId != null
                      ? locationController.states.firstWhereOrNull((e) => e.id == _selectedStateId)?.name
                      : null,
                  options: locationController.states.map((e) => e.name).toList(),
                  onChanged: (val) {
                    final selected = locationController.states.firstWhereOrNull((e) => e.name == val);
                    setState(() {
                      _selectedStateId = selected?.id;
                      _selectedCityId = null;
                      _selectedAreaId = null;
                    });
                    if (selected != null) {
                      locationController.fetchCities(context, selected.id);
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'City',
                  value: _selectedCityId != null
                      ? locationController.cities.firstWhereOrNull((e) => e.id == _selectedCityId)?.name
                      : null,
                  options: locationController.cities.map((e) => e.name).toList(),
                  onChanged: (val) {
                    final selected = locationController.cities.firstWhereOrNull((e) => e.name == val);
                    setState(() {
                      _selectedCityId = selected?.id;
                      _selectedAreaId = null;
                    });
                    if (selected != null) {
                      locationController.fetchAreas(context, selected.id);
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'Area',
                  value: _selectedAreaId != null
                      ? locationController.areas.firstWhereOrNull((e) => e.id == _selectedAreaId)?.name
                      : null,
                  options: locationController.areas.map((e) => e.name).toList(),
                  onChanged: (val) {
                    final selected = locationController.areas.firstWhereOrNull((e) => e.name == val);
                    setState(() => _selectedAreaId = selected?.id);
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'Occupation',
                  value: _selectedOccupationId != null
                      ? locationController.occupations.firstWhereOrNull((e) => e.id == _selectedOccupationId)?.name
                      : null,
                  options: locationController.occupations.map((e) => e.name).toList(),
                  onChanged: (val) {
                    final selected = locationController.occupations.firstWhereOrNull((e) => e.name == val);
                    setState(() => _selectedOccupationId = selected?.id);
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  label: 'Marital Status',
                  value: _selectedMaritalStatusId != null
                      ? locationController.maritalStatuses.firstWhereOrNull((e) => e.id == _selectedMaritalStatusId)?.name
                      : null,
                  options: locationController.maritalStatuses.map((e) => e.name).toList(),
                  onChanged: (val) {
                    final selected = locationController.maritalStatuses.firstWhereOrNull((e) => e.name == val);
                    setState(() => _selectedMaritalStatusId = selected?.id);
                  },
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      bool success = await createAccountController.completeProfile(
                        context: context,
                        firstName: _nameController.text,
                        dateOfBirth: _dobController.text,
                        gender: _selectedGenderId ?? '',
                        country: _selectedCountryId ?? '',
                        state: _selectedStateId ?? '',
                        city: _selectedCityId ?? '',
                        area: _selectedAreaId ?? '',
                        occupation: _selectedOccupationId ?? '',
                        maritalStatus: _selectedMaritalStatusId ?? '',
                      );
                      setState(() => _isLoading = false);
                      if (success && mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => InterestSelectionScreen()),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF426DB3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('Complete Profile',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: Icon(icon, color: const Color(0xFF426DB3)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
        ),
      ],
    );
  }
}
