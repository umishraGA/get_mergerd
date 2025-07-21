import 'package:flutter/material.dart';

class RequestQuoteForm extends StatefulWidget {
  const RequestQuoteForm({super.key});

  @override
  State<RequestQuoteForm> createState() => _RequestQuoteFormState();
}

class _RequestQuoteFormState extends State<RequestQuoteForm> {
  final _productNameController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _productNameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Haven't found what you want ?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Post request and get quotations quickly',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF909090),
            ),
          ),
          const SizedBox(height: 16),

          // Product/Service name field
          TextField(
            controller: _productNameController,
            decoration: InputDecoration(
              hintText: 'Product/Service name',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Detail requirements field
          TextField(
            controller: _detailsController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Detail Requirement Like Size, Quantity Etc.',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Request for quote button
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _submitQuoteRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF3340),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Request For Quote',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitQuoteRequest() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Get input values
    final productName = _productNameController.text.trim();
    final details = _detailsController.text.trim();

    // Validate input
    if (productName.isEmpty) {
      _showErrorSnackBar('Please enter a product or service name');
      return;
    }

    // In a real app, submit this data to a backend API
    // For now, just show a success message
    _showSuccessSnackBar('Quote request submitted successfully!');

    // Clear form
    _productNameController.clear();
    _detailsController.clear();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
