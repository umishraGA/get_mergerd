import 'package:flutter/material.dart';
import 'package:myapp/features/postDetail/TestDescriptionPage.dart';

void main() {
  runApp(const MyTestApp());
}

class MyTestApp extends StatelessWidget {
  const MyTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read More/Less Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'FacebookSans',
      ),
      home: const TestDescriptionPage(),
    );
  }
}
