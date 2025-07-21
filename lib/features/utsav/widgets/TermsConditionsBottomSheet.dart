import 'package:flutter/material.dart';

class TermsConditionsBottomSheet extends StatelessWidget {
  const TermsConditionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample steps list - this could be passed as a parameter for dynamic steps
    final List<Map<String, String>> redemptionSteps = [
      {
        'number': '1',
        'text':
            'Visit any Wow! China outlet listed on the happening bazar app where E-Gift Vouchers are applicable.'
      },
      {
        'number': '2',
        'text': 'Go to "My Transactions" in the "Account" section on the app'
      },
      {
        'number': '3',
        'text': 'Show the voucher code to the cashier at the time of billing'
      },
      {
        'number': '4',
        'text': 'The voucher amount will be deducted from your final bill'
      },
      {
        'number': '5',
        'text': 'Enjoy your meal with the discount applied to your order'
      },
      {
        'number': '6',
        'text': 'Remember to rate your experience after using the voucher'
      },
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, -2.0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4A76C5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Single voucher applicable text
              const Text(
                'Single voucher applicable per bill.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Non refundable point
              const Text(
                'a. Non Refundable.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Validity days section
              const Text(
                'Validity - ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildValidityDay('S', true),
                  _buildValidityDay('M', true),
                  _buildValidityDay('T', true),
                  _buildValidityDay('W', true),
                  _buildValidityDay('T', true),
                  _buildValidityDay('F', true),
                  _buildValidityDay('S', true),
                ],
              ),
              const SizedBox(height: 24),

              // How to Redeem section
              const Text(
                'How to Redeem',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Redemption steps
              Column(
                children: [
                  for (var step in redemptionSteps)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildRedemptionStep(
                        step['number']!,
                        step['text']!,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidityDay(String day, bool isValid) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isValid ? const Color(0xFF4A76C5) : Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: isValid ? Colors.white : Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRedemptionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEF3340),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
