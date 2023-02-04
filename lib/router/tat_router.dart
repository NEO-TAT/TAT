// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import 'package:tat/pages/login_page.dart';
import 'package:tat/pages/tat_main_page.dart';
import 'package:tat/router/observer.dart';

final _mainPageRoute = GoRoute(
  path: '/',
  name: TATMainPage.routeName,
  builder: (_, state) => TATMainPage(
    key: state.pageKey,
  ),
);

final _loginPageRoute = GoRoute(
  path: '/${LoginPage.routeName}',
  name: LoginPage.routeName,
  pageBuilder: (_, state) {
    final params = state.extra as LoginPageRouteParams?;
    return MaterialPage<void>(
      key: state.pageKey,
      restorationId: state.pageKey.value,
      fullscreenDialog: true,
      name: LoginPage.routeName,
      child: LoginPage(
        key: state.pageKey,
        loginSuccessAction: params?.loginSuccessAction,
      ),
    );
  },
);

final tatRouter = GoRouter(
  initialLocation: '/${TATMainPage.routeName}',
  observers: [RouteNavigationObserver()],
  routes: [
    _mainPageRoute,
    _loginPageRoute,
  ],
);
