import 'package:flutter/material.dart';

class CommonDivider extends StatelessWidget {
  const CommonDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
              color: Color(0xFFEEEEEE),
              height: 1,
              thickness: 1,
            );
  }
}