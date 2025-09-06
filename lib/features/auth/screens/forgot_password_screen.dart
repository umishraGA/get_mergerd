import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? email;

  const ForgotPasswordScreen({
    this.mobileNumber,
    this.email,
    super.key,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late bool _useMobile;

  @override
  void initState() {
    super.initState();

    // Initialize mobile controller with provided value or empty
    _mobileController = TextEditingController(text: widget.mobileNumber);

    // Initialize email controller with provided value or a temporary email
    _emailController = TextEditingController(
        text: widget.email?.isNotEmpty == true
            ? widget.email
            : 'user@example.com');

    // Set the active option based on what's provided (prefer mobile if both are provided)
    if (widget.mobileNumber != null && widget.mobileNumber!.isNotEmpty) {
      _useMobile = true;
    } else if (widget.email != null && widget.email!.isNotEmpty) {
      _useMobile = false;
    } else {
      _useMobile = true; // Default to mobile if neither is provided
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordOTPScreen(
            contactType: _useMobile ? 'mobile' : 'email',
            contact:
                _useMobile ? _mobileController.text : _emailController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Top section with image
            Stack(
              children: [
                // Background image with gradient overlay
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Stack(
                    children: [
                      // Image
                      Image.asset(
                        'assets/images/signin/signin.png',
                        width: double.infinity,
                        height: size.height * 0.35,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay
                      Container(
                        width: double.infinity,
                        height: size.height * 0.35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                SafeArea(
                  child: Container(
                    height: size.height * 0.35,
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF426DB3),
                                  size: 20,
                                ),
                              ),
                            ),
                            // Reset icon on right
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF426DB3),
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        // Bottom content - title and subtitle
                        Column(
                          children: [
                            // Lock icon with white circle
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.lock_reset_rounded,
                                color: Color(0xFF426DB3),
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Title with white text for contrast against dark gradient
                            const Text(
                              'Reset Your Password',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Subtitle
                            const Text(
                              'Secure your account with a new password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Select which contact details should we use to reset your password',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Mobile Option
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: _useMobile ? 0 : 4,
                          right: _useMobile ? 4 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _useMobile = true),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _useMobile
                                    ? const Color(0xFF426DB3)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              boxShadow: _useMobile
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF426DB3)
                                            .withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF426DB3)
                                            .withOpacity(0.05),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                            ),
                            child: Row(
                              children: [
                                // Icon container with shimmer effect when selected
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _useMobile
                                        ? const Color(0xFF426DB3)
                                            .withOpacity(0.15)
                                        : const Color(0xFF426DB3)
                                            .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.phone_android,
                                    color: _useMobile
                                        ? const Color(0xFF426DB3)
                                        : const Color(0xFF426DB3)
                                            .withOpacity(0.7),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'via SMS:',
                                        style: TextStyle(
                                          color: Color(0xFF909090),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (_useMobile)
                                        TextFormField(
                                          controller: _mobileController,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Enter your mobile number',
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                          validator: _validateMobile,
                                          readOnly: widget.mobileNumber != null,
                                        )
                                      else
                                        Text(
                                          _mobileController.text.isNotEmpty
                                              ? '+91 ${_mobileController.text}'
                                              : 'Enter mobile number',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.grey.shade400,
                                  ),
                                  child: Radio(
                                    value: true,
                                    groupValue: _useMobile,
                                    onChanged: (value) =>
                                        setState(() => _useMobile = true),
                                    activeColor: const Color(0xFF426DB3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Email Option with the same animation effect
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: !_useMobile ? 0 : 4,
                          right: !_useMobile ? 4 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _useMobile = false),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: !_useMobile
                                    ? const Color(0xFF426DB3)
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              boxShadow: !_useMobile
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF426DB3)
                                            .withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF426DB3)
                                            .withOpacity(0.05),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                            ),
                            child: Row(
                              children: [
                                // Icon with shimmer effect
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: !_useMobile
                                        ? const Color(0xFF426DB3)
                                            .withOpacity(0.15)
                                        : const Color(0xFF426DB3)
                                            .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: !_useMobile
                                        ? const Color(0xFF426DB3)
                                        : const Color(0xFF426DB3)
                                            .withOpacity(0.7),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'via Email:',
                                        style: TextStyle(
                                          color: Color(0xFF909090),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (!_useMobile)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller: _emailController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Enter your email address',
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: _validateEmail,
                                              readOnly: widget.email != null,
                                            ),
                                            if (widget.email == null &&
                                                _emailController.text ==
                                                    'user@example.com')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  'Temporary email for demonstration',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      else
                                        Text(
                                          _emailController.text.isNotEmpty
                                              ? _emailController.text
                                              : 'Enter email address',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.grey.shade400,
                                  ),
                                  child: Radio(
                                    value: false,
                                    groupValue: _useMobile,
                                    onChanged: (value) =>
                                        setState(() => _useMobile = false),
                                    activeColor: const Color(0xFF426DB3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Continue Button with improved styling
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF426DB3).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF426DB3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
