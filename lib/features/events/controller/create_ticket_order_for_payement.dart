// controllers/payment_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../utils/dio/auth_helper.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var orderResponse = {}.obs;
  var paymentVerificationStatus = false.obs;
  Razorpay? _razorpay;

  // Store payment details for verification
  String? _currentOrderId;
  String? _currentPaymentId;
  String? _currentSignature;

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay?.clear();
    super.onClose();
  }
  Future<void> freeTicketBook({
    required String eventId,
    required String tickettype,
    required int quantity,
    required String bookedDate,

    required BuildContext context,
  }) async
  {
    try {
      isLoading.value = true;

      var url = Uri.parse("https://api.gamsgroup.in/user/event/book-ticket");

      var body = {
        "Eventid": eventId,
        "quantity": quantity,
        "tickettype": tickettype,
        "bookeddate": bookedDate,

      };

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(context, "Success", "Ticket booked Successfuly");

      } else {
        print("❌ Failed: ${response.body}");
        _showSnackBar(context, "Error", "Failed to create order");
      }
    } catch (e) {
      print("❌ Exception: $e");
      _showSnackBar(context, "Error", "An error occurred while creating order");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPaymentOrder({
    required String eventId,
    required String ticketId,
    required int quantity,
    required String bookedDate,
    String paidVia = "Razorpay",
    required BuildContext context,
  }) async
  {
    try {
      isLoading.value = true;

  

      if (_razorpay == null) {
        _initializeRazorpay();
      }

      var url = Uri.parse("https://api.gamsgroup.in/user/event/payment");

      var body = {
        "Eventid": eventId,
        "quantity": quantity,
        "Ticketid": ticketId,
        "bookeddate": bookedDate,
        "paid_via": paidVia,
      };

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        orderResponse.value = data as Map<dynamic, dynamic>;
        print("✅ Order Created: ${data["id"]}");

        // Store order ID for verification
        _currentOrderId = data["id"]?.toString();

        // Parse amount safely
        int amount = 000;
        if (data["amount"] != null) {
          if (data["amount"] is int) {
            amount = int.parse(data["amount"].toString());
          } else if (double.parse(data["amount"].toString()) is double) {
            amount = int.parse(data["amount"].toString()).toInt();
          } else if (data["amount"] is String) {
            amount = int.tryParse(data["amount"].toString()) ?? 11800;
          }
        }

        _openRazorpayCheckout(
          orderId: _currentOrderId!,
          amount: amount,
          context: context,
        );
      } else {
        print("❌ Failed: ${response.body}");
        _showSnackBar(context, "Error", "Failed to create order");
      }
    } catch (e) {
      print("❌ Exception: $e");
      _showSnackBar(context, "Error", "An error occurred while creating order");
    } finally {
      isLoading.value = false;
    }
  }

  void _openRazorpayCheckout({
    required String orderId,
    required int amount,
    required BuildContext context,
  }) {
    if (_razorpay == null) {
      _showSnackBar(context, "Error", "Payment gateway not initialized");
      return;
    }

    var options = {
      'key': 'rzp_test_jlRnA6xIiPtlwx',
      'amount': amount,
      'name': 'Event Booking',
      'description': 'Ticket Payment',
      'order_id': orderId,
      'timeout': 300,
      'prefill': {
        'contact': '8888888888',
        'email': 'user@example.com'
      },
      'theme': {
        'color': '#007AFF'
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      print("❌ Razorpay Error: $e");
      _showSnackBar(context, "Error", "Failed to open payment gateway: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final context = Get.context;

    // Store payment details for verification
    _currentPaymentId = response.paymentId;
    _currentSignature = response.signature;

    print("✅ Payment Success: ${response.paymentId}");
    print("✅ Order ID: ${response.orderId}");
    print("✅ Signature: ${response.signature}");

    // Verify payment with server
    if (_currentOrderId != null && _currentPaymentId != null && _currentSignature != null) {
      _verifyPayment(
        signature: _currentSignature!,
        paymentId: _currentPaymentId!,
        orderId: _currentOrderId!,
      );
    } else {
      if (context != null) {
        _showSnackBar(context, "Error", "Payment details incomplete for verification");
      }
    }

    if (context != null) {
      _showSnackBar(context, "Success", "Payment Successful! Verifying...");
    }
  }

  Future<void> _verifyPayment({
    required String signature,
    required String paymentId,
    required String orderId,
  }) async
  {
    try {
     

      var url = Uri.parse("https://api.gamsgroup.in/user/event/verifyPayment");

      var body = {
        "signature": signature,
        "payment_id": paymentId,
        "order_id": orderId,
      };

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
        },
        body: jsonEncode(body),
      );

      print("🔍 Verification Response: ${response.statusCode}");
      print("🔍 Verification Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["success"] == true) {
          paymentVerificationStatus.value = true;
          print("✅ Payment Verification Successful!");

          final context = Get.context;
          if (context != null) {
            _showSnackBar(context, "Success", "Payment verified successfully!");
          }

          // TODO: Navigate to success screen or update UI
        } else {
          print("❌ Payment Verification Failed: ${data["message"]}");

          final context = Get.context;
          if (context != null) {
            _showSnackBar(context, "Error", "Payment verification failed: ${data["message"]}");
          }
        }
      } else {
        print("❌ Verification API Error: ${response.statusCode}");

        final context = Get.context;
        if (context != null) {
          _showSnackBar(context, "Error", "Verification server error: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("❌ Verification Exception: $e");

      final context = Get.context;
      if (context != null) {
        _showSnackBar(context, "Error", "Verification failed: $e");
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final context = Get.context;
    if (context != null) {
      _showSnackBar(context, "Payment Failed", "Error: ${response.message}");
    }
    print("❌ Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    final context = Get.context;
    if (context != null) {
      _showSnackBar(context, "Info", "Redirected to: ${response.walletName}");
    }
    print("🔄 External Wallet: ${response.walletName}");
  }

  void _showSnackBar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: title == "Error" ? Colors.red :
        title == "Success" ? Colors.green : Colors.blue,
        duration: Duration(seconds: 4),
      ),
    );
  }


}