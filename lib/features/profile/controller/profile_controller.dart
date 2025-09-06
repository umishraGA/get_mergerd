import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/utils/dio/auth_helper.dart';

class UserDetailsController extends GetxController {
  var isLoading = false.obs;
  var userData = {}.obs;

  final String baseUrl = "https://api.gamsgroup.in/user/basic/user-details";

  Future<void> fetchUserDetails() async {
    try {
  
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          userData.value = data['data'] as Map<dynamic, dynamic>;
        } else {
          Get.snackbar("Error", data['message']?.toString() ?? "Something went wrong");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch user details");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}



class UserDetailsView extends StatelessWidget {
  UserDetailsView({super.key,});

  final UserDetailsController controller = Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    controller.fetchUserDetails();

    return Scaffold(
      appBar: AppBar(title: const Text("User Details")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.userData.isEmpty) {
          return const Center(child: Text("No user data found"));
        }

        final user = controller.userData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user['image']?.toString() ?? ""),
              ),
              const SizedBox(height: 10),
              Text("${user['firstName']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("${user['email']}"),
              Text("Phone: ${user['phone']}"),
              const Divider(),
              ListTile(
                title: const Text("Gender"),
                subtitle: Text(user['gender']?['name']?.toString() ?? "-"),
              ),
              ListTile(
                title: const Text("Marital Status"),
                subtitle: Text(user['maritalStatus']?['name']?.toString() ?? "-"),
              ),
              ListTile(
                title: const Text("Occupation"),
                subtitle: Text(user['occupation']?['name']?.toString() ?? "-"),
              ),
              ListTile(
                title: const Text("City"),
                subtitle: Text(user['city']?['name']?.toString() ?? "-"),
              ),
              ListTile(
                title: const Text("State"),
                subtitle: Text(user['state']?['name']?.toString() ?? "-"),
              ),
              ListTile(
                title: const Text("Country"),
                subtitle: Text(user['country']?['name']?.toString() ?? "-"),
              ),
              ListTile(
                title: const Text("Coins"),
                subtitle: Text("${user['coins']}"),
              ),
              const Divider(),

            ],
          ),
        );
      }),
    );
  }
}
