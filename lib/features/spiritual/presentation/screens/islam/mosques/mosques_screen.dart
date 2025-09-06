import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Islam_controller/mosques_controller.dart';

class MosquesScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MosquesScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<MosquesScreen> createState() => _MosquesScreenState();
}

class _MosquesScreenState extends State<MosquesScreen> {
  final MosqueController mosqueController = Get.put(MosqueController());

  @override
  void initState() {
    super.initState();
    mosqueController.fetchMosques(lat: widget.latitude, lon: widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Mosques',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.map,
              color: Colors.green,
              size: 24,
            ),
            onPressed: () {
              // Optional: Open a general map view
            },
          ),
        ],
      ),
      body: Obx(() {
        if (mosqueController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (mosqueController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              mosqueController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (mosqueController.mosqueList.isEmpty) {
          return const Center(child: Text("No mosques found."));
        }

        return ListView.builder(
          itemCount: mosqueController.mosqueList.length,
          itemBuilder: (context, index) {
            MosqueModel mosque = mosqueController.mosqueList[index];
            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.mosque, color: Colors.green),
                title: Text(mosque.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${mosque.area}, ${mosque.city}"),
                  ],
                ),
                trailing: Text("${mosque.distance.toStringAsFixed(2)} km"),
                onTap: () {
                  final lat = mosque.latitude;
                  final lon = mosque.longitude;
                  final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
