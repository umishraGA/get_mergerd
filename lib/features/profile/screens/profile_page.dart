import 'package:flutter/material.dart';
import 'package:myapp/features/profile/screens/profile_screen.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}
