// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:tat/pages/tat_main_page.dart';

class TATRouter {
  static Route createRoute(RouteSettings settings) {
    switch (settings.name) {
      case TATMainPage.routeId:
        return MaterialPageRoute<TATMainPage>(
          builder: (_) => TATMainPage(),
          settings: settings,
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SizedBox.shrink(),
        );
    }
  }

  static List<Route> createInitialRoutes(String initialRoute) {
    final rootRoute = createRoute(const RouteSettings(name: TATMainPage.routeId));
    return [rootRoute];
  }
}
