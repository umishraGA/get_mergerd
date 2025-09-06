import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'create_new_password_screen.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {
  final String contactType;
  final String contact;

  const ForgotPasswordOTPScreen({
    super.key,
    required this.contactType,
    required this.contact,
  });

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  Timer? _resendTimer;
  int _timeLeft = 60;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();

    // Add listeners to handle auto-verification when all fields are filled
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        _checkAllFieldsFilled();
      });
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Check if all OTP fields are filled and dismiss keyboard if true
  void _checkAllFieldsFilled() {
    bool allFilled = true;
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        allFilled = false;
        break;
      }
    }

    if (allFilled) {
      // Close keyboard when all fields are filled
      FocusScope.of(context).unfocus();

      // Auto-verify after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _handleVerification();
      });
    }
  }

  void startTimer() {
    _resendTimer?.cancel();
    setState(() {
      _timeLeft = 60;
    });
    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_timeLeft == 0) {
          timer.cancel();
        } else {
          setState(() {
            _timeLeft--;
          });
        }
      },
    );
  }

  String get formattedTime {
    final minutes = (_timeLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get maskedContact {
    if (widget.contactType == 'mobile') {
      return widget.contact.replaceRange(2, 8, '******');
    } else {
      final parts = widget.contact.split('@');
      if (parts.length == 2) {
        final username = parts[0];
        final domain = parts[1];
        final maskedUsername = username.length > 3
            ? '${username.substring(0, 3)}${'*' * (username.length - 3)}'
            : username;
        return '$maskedUsername@$domain';
      }
      return widget.contact;
    }
  }

  // Move to next field when number is entered
  void _moveToNextField(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Close keyboard when last field is filled
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _handleVerification() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      setState(() => _isLoading = false);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateNewPasswordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside of text fields
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF426DB3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/otp_icon.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.security,
                        size: 60,
                        color: Color(0xFF426DB3),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'OTP Sent',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF426DB3),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the verification code we just\nsent on your ${widget.contactType}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF909090),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Code has been sent to $maskedContact',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF909090),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 60,
                    height: 60,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (RawKeyEvent event) {
                        if (event is RawKeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.backspace &&
                            _controllers[index].text.isEmpty &&
                            index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFF426DB3),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF426DB3), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          _moveToNextField(value, index);
                        },
                        onSubmitted: (_) {
                          // Close keyboard when user presses done
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Resend code ',
                    style: TextStyle(
                      color: Color(0xFF909090),
                    ),
                  ),
                  GestureDetector(
                    onTap: _timeLeft == 0 ? startTimer : null,
                    child: Text(
                      _timeLeft > 0 ? formattedTime : 'Resend',
                      style: TextStyle(
                        color: const Color(0xFF426DB3),
                        fontWeight: FontWeight.bold,
                        decoration:
                            _timeLeft == 0 ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF426DB3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                    disabledBackgroundColor:
                        const Color(0xFF426DB3).withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify',
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
    );
  }
}
