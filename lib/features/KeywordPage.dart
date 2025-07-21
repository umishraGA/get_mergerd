import 'package:flutter/material.dart';

class KeywordPage extends StatelessWidget {
  final String keyword;

  const KeywordPage({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Keyword: $keyword')),
      body: Center(
        child: Text(
          'You tapped: $keyword',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
} 