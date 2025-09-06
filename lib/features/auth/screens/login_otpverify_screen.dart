import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../utils/dio/auth_helper.dart';
import '../../location/LocationPermissionPage.dart';
import '../../mainPage/MainPage.dart';
import '../controller/login_otpsend_controller.dart';

class LoginOtpverifyScreen extends StatefulWidget {
  final String mobileNumber;
  const LoginOtpverifyScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<LoginOtpverifyScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<LoginOtpverifyScreen> with CodeAutoFill {
  final LoginOtpController signupOtpController = Get.put(LoginOtpController());
  final SmsAutoFill _smsAutoFill = SmsAutoFill();

  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _resendTimer;
  int _timeLeft = 60;
  bool _isLoading = false;
  String? _appSignature;

  @override
  void initState() {
    super.initState();
    startTimer();
    _initSmsAutofill();

    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(_checkAllFieldsFilled);
    }
  }

  Future<void> _initSmsAutofill() async {
    try {
      // Get app signature
      _appSignature = await _smsAutoFill.getAppSignature;
      print("App Signature: $_appSignature");

      // Listen for incoming SMS
      listenForCode();

    } catch (e) {
      print("Error initializing SMS autofill: $e");
    }
  }

  @override
  void codeUpdated() {
    if (code != null && code!.isNotEmpty) {
      print("Received code via auto-fill: $code");

      if (code!.length == 6) {
        _fillOtpFields(code!);

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _handleVerification();
        });
      }
    }
  }

  void _fillOtpFields(String code) {
    for (int i = 0; i < 6 && i < code.length; i++) {
      _controllers[i].text = code[i];
      _controllers[i].selection = TextSelection.fromPosition(
          TextPosition(offset: _controllers[i].text.length));
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    _smsAutoFill.unregisterListener();
    cancel();
    super.dispose();
  }

  void _checkAllFieldsFilled() {
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      FocusScope.of(context).unfocus();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _handleVerification();
      });
    }
  }

  void startTimer() {
    _resendTimer?.cancel();
    setState(() => _timeLeft = 60);

    signupOtpController.sendLoginOtp(context, widget.mobileNumber);

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  String get formattedTime {
    final minutes = (_timeLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _handleVerification() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      setState(() => _isLoading = true);

      bool isVerified = await signupOtpController.verifyLoginOtp(
        context,
        widget.mobileNumber,
        otp,
      );

      setState(() => _isLoading = false);

      if (isVerified) {
        if (AuthHelper.hasRequiredPermissions) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MainPage()));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LocationPermissionPage(
                isMandatory: true,
                onPermissionGranted: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const MainPage()));
                },
                onPermissionDenied: _handlePermissionDenied,
              ),
            ),
          );
        }
      }
    }
  }

  void _handlePermissionDenied() async {
    await AuthHelper.clearAuthData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location permission is required to use this app.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _moveToNextField(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF426DB3),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit code sent to your \nmobile ${widget.mobileNumber.replaceRange(2, 8, '******')}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Color(0xFF909090)),
              ),
              const SizedBox(height: 25),

              // OTP fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6, (index) {
                  ever(signupOtpController.otpCode, (String code) {
                    if (code.length == 6) {
                      _controllers[index].text = code;
                    }
                  });
                    return SizedBox(
                          width: 45,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            autofillHints: const [AutofillHints.oneTimeCode],
                            style: const TextStyle(
                              fontSize: 26,
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 10),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) => _moveToNextField(value, index),
                          ),
                        );
                      },
                ),
              ),

              const SizedBox(height: 20),

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Resend code ',
                      style: TextStyle(color: Color(0xFF909090))),
                  GestureDetector(
                    onTap: _timeLeft == 0 ? startTimer : null,
                    child: Text(
                      _timeLeft > 0 ? formattedTime : 'Resend',
                      style: TextStyle(
                        color: const Color(0xFF426DB3),
                        fontWeight: FontWeight.bold,
                        decoration: _timeLeft == 0
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF426DB3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                        color: Colors.white),
                  ),
                ),
              ),

              // Debug information
              const SizedBox(height: 20),
              Obx(() => Text(
                signupOtpController.message.value.isEmpty
                    ? "Waiting for OTP..."
                    : signupOtpController.message.value,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
      ),
    );
  }
}