import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/sign_up_controller.dart';
import 'sign_up_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final bool isSignUp;

  const OTPVerificationScreen({
    super.key,
    required this.mobileNumber,
    this.isSignUp = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final SignupOtpController signupOtpController =
  Get.put(SignupOtpController());
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (index) => FocusNode());

  final SignupOtpController _otpController = Get.put(SignupOtpController());

  Timer? _resendTimer;
  int _timeLeft = 60;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();

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

  void _checkAllFieldsFilled() {
    bool allFilled =
    _controllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      FocusScope.of(context).unfocus();
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

    // ✅ Call API to resend OTP
    _otpController.sendSignupOtp(context, widget.mobileNumber);

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          _timeLeft--;
        });
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

      bool isVerified = await signupOtpController.verifySignUpOtp(
        context: context,
        phone: widget.mobileNumber,
        otp: otp,
      );

      setState(() => _isLoading = false);

      if (isVerified) {
        // ✅ Navigate only if OTP is verified successfully
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              verifiedOtp: otp,
            ),
          ),
        );
      }
    }
  }
  void _moveToNextField(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF426DB3),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the 6-digit code sent to your mobile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF909090)),
              ),
              const SizedBox(height: 8),
              Text(
                'Sent to ${widget.mobileNumber.replaceRange(2, 8, '******')}',
                style:
                const TextStyle(fontSize: 14, color: Color(0xFF909090)),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 45,
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
                          fontSize: 26,
                          color: Color(0xFF426DB3),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF426DB3), width: 2),
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                          fillColor: Colors.white,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          _moveToNextField(value, index);
                        },
                        onSubmitted: (_) {
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
