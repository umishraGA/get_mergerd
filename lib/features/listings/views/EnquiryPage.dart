import 'package:flutter/material.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:myapp/features/utsav/UtsavViewModel.dart';
import 'package:myapp/features/utsav/UtsavRepository.dart';
import 'package:myapp/utils/dio/api_service.dart';
import '../models/EnquiryModels.dart';

class EnquiryPage extends StatefulWidget {
  final String clinicName;
  final String category;
  final String subCategory;
  final String businessId;

  const EnquiryPage({
    super.key,
    required this.clinicName,
    required this.category,
    required this.subCategory,
    required this.businessId,
  });

  @override
  State<EnquiryPage> createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  final _productController = TextEditingController();
  final _detailsController = TextEditingController();
  late final UtsavViewModel _viewModel;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _viewModel = UtsavViewModel(
        repository: UtsavRepository(apiService: ApiService()));
  }

  @override
  void dispose() {
    _productController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitEnquiry() async {
    final serviceName = _productController.text.trim();
    final details = _detailsController.text.trim();

    if (serviceName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter product/service name')),
      );
      return;
    }

    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter requirement details')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = SaveEnquiryRequest(
        businessId: widget.businessId,
        serviceName: serviceName,
        details: details,
      );

      final response = await _viewModel.saveEnquiry(request);

      if (response.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enquiry submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Clear the form
        _productController.clear();
        _detailsController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to submit enquiry'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SingleChildScrollView(
          child: Column(children: [
        const AppHeader(title: "Enquiry"),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connect with Verified Suppliers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Request For Quotation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    widget.category,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                  Text(
                    widget.subCategory,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'To : ${widget.clinicName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _productController,
                decoration: InputDecoration(
                  hintText: 'Product/Service name',
                  hintStyle: const TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _detailsController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Detail Requirement Like Size, Quantity Etc.',
                  hintStyle: const TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitEnquiry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED3237),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'How to use',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildHowToUseStep(
                '1. Submit RFQ',
                'Tell us what you need. Post your requirement',
              ),
              const SizedBox(height: 20),
              _buildHowToUseStep(
                '2. Connect with verified businesses',
                'Tell us what you need. Post your requirement',
              ),
            ],
          ),
        ),
      ])),
    );
  }

  Widget _buildHowToUseStep(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
