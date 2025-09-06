import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyApp"),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Welcome to Neat Roots",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Replace with your own logo asset
                Image(image: AssetImage('assets/images/ss.png'),
                  // example logo url
                  height: 150,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Like"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Subscribe"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}