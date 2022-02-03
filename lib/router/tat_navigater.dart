// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:tat/keys.dart';
import 'package:tat/pages/login_page.dart';
import 'package:tat/pages/tat_main_page.dart';

class TATNavigator {
  // TODO(TU): Ensure the `_navigator` is always non null.
  NavigatorState get _navigator => TATKeyProvider.navigatorKey.currentState!;

  Future<void> launchLoginPage() async => _navigator.pushNamed(LoginPage.routeId);

  static Route _createLoginPageRoute(RouteSettings settings) {
    final params = settings.arguments as LoginPageRouteParams?;
    final loginPage = LoginPage(
      loginSuccessAction: params?.loginSuccessAction,
    );
    return MaterialPageRoute<LoginPage>(
      builder: (_) => loginPage,
      fullscreenDialog: true,
      settings: settings,
    );
  }

  static Route createRoute(RouteSettings settings) {
    switch (settings.name) {
      case TATMainPage.routeId:
        return MaterialPageRoute<TATMainPage>(
          builder: (_) => TATMainPage(),
          settings: settings,
        );
      case LoginPage.routeId:
        return _createLoginPageRoute(settings);
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
