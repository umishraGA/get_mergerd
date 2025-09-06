import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void navigateToHome() {
    Restart.restartApp();
  }
}
