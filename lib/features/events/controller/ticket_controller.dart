import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

<<<<<<< HEAD
import '../../../utils/dio/auth_helper.dart';

=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b

class BookedTicket {
  final String id;
  final String orderId;
  final Event event;
  final String ticketId;
  final String bookedDate;
  final int quantity;
  final double custPaid;
  final String paidVia;
  final String status;
  final String transactionId;

  BookedTicket({
    required this.id,
    required this.orderId,
    required this.event,
    required this.ticketId,
    required this.bookedDate,
    required this.quantity,
    required this.custPaid,
    required this.paidVia,
    required this.status,
    required this.transactionId,
  });

  factory BookedTicket.fromJson(Map<String, dynamic> json) {
    return BookedTicket(
      id: json['_id']?.toString() ?? '',
      orderId: json['orderid']?.toString() ?? '',
      event: Event.fromJson(json['Eventid'] as Map<String, dynamic>),
      ticketId: json['ticketid']?.toString() ?? '',
      bookedDate: json['bookeddate'] ?.toString()?? '',
      quantity: int.parse(json['quantity'].toString())?? 0,
      custPaid: (double.parse(json['cust_paid'].toString()) ?? 0).toDouble(),
      paidVia: json['paid_via'] ?.toString()?? '',
      status: json['status']?.toString() ?? '',
      transactionId: json['transactionid']?.toString() ?? '',
    );
  }
}

class Event {
  final String id;
  final String eventTitle;

  Event({
    required this.id,
    required this.eventTitle,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id']?.toString() ?? '',
      eventTitle: json['event_title'] ?.toString()?? '',
    );
  }
}

class BookedTicketController extends GetxController {
  RxList<BookedTicket> bookedTickets = <BookedTicket>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final String baseUrl = "{{vps}}/user/event/booked-ticket"; // replace {{vps}}

  Future<void> fetchBookedTickets() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
<<<<<<< HEAD
=======
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        errorMessage.value = "Token not found!";
        isLoading.value = false;
        return;
      }
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
<<<<<<< HEAD
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
=======
          "Authorization": "Bearer $token",
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        List<dynamic> data = body['data'] as List<dynamic>;

        bookedTickets.value =
            data.map((item) => BookedTicket.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        errorMessage.value =
        "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage.value = "Exception: $e";
    }

    isLoading.value = false;
  }
}
