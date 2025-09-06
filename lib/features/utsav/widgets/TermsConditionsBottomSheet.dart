import 'package:flutter/material.dart';

class TermsConditionsBottomSheet extends StatelessWidget {
  final String? title;
  final String? description;
  final List<String>? redeemDays;
  final List<String>? howToRedeem;
  final String? terms;
  final String? redeemOnSingleBill;

  const TermsConditionsBottomSheet({
    super.key,
    this.title,
    this.description,
    this.redeemDays,
    this.howToRedeem,
    this.terms,
    this.redeemOnSingleBill,
  });

  @override
  Widget build(BuildContext context) {
    // Use dynamic steps from coupon data or fallback to default
    final List<Map<String, String>> redemptionSteps = _buildRedemptionSteps();

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
                  Text(
                    title ?? 'Terms & Conditions',
                    style: const TextStyle(
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

              // Description from coupon
              if (description != null) ...[
                Text(
                  description!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Single voucher applicable text
              Text(
                redeemOnSingleBill ?? 'Single voucher applicable per bill.',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Terms from coupon
              if (terms != null) ...[
                Text(
                  terms!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Default non refundable point if no terms provided
              if (terms == null)
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
                children: _buildValidityDays(),
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

  List<Map<String, String>> _buildRedemptionSteps() {
    if (howToRedeem != null && howToRedeem!.isNotEmpty) {
      return howToRedeem!.asMap().entries.map((entry) {
        return {
          'number': (entry.key + 1).toString(),
          'text': entry.value,
        };
      }).toList();
    }
    
    // Default steps if no data provided
    return [
      {
        'number': '1',
        'text': 'Visit the outlet where vouchers are applicable.'
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
    ];
  }

  List<Widget> _buildValidityDays() {
    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    
    if (redeemDays != null && redeemDays!.isNotEmpty) {
      return dayLabels.asMap().entries.map((entry) {
        final index = entry.key;
        final dayLabel = entry.value;
        final dayName = dayNames[index];
        final isValid = redeemDays!.any((day) => 
          day.toLowerCase().contains(dayName.toLowerCase()) ||
          day.toLowerCase().contains(dayLabel.toLowerCase())
        );
        return _buildValidityDay(dayLabel, isValid);
      }).toList();
    }
    
    // Default: all days valid if no data provided
    return dayLabels.map((day) => _buildValidityDay(day, true)).toList();
  }
}
