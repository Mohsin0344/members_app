import 'package:flutter/material.dart';
import '../utils/route_names.dart';
import '../views/dashboard_screen.dart';

class AppRoutes {
  Route? generateRoute(RouteSettings settings) {
    FocusManager.instance.primaryFocus?.unfocus();
    final args = settings.arguments;
    switch (settings.name) {
      case RouteNames.dashboardScreen:
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        );
    }
  }
}
