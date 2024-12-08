// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../presentation/homepage/homepage.dart';
import '../presentation/homepage/comparison.dart';

class AppRoutes {
  static const String home = '/';
  static const String comparison = '/comparison';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home'));
      case comparison:
        return MaterialPageRoute(builder: (_) => const ComparisonPage());
      default:
        return MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home'));
    }
  }
}
