// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 🌎 Project imports:
import 'package:tat/utils/debug_log.dart';

/// A navigator observer recording the route navigation history according to the navigation change of [didPop],
/// [didPush], [didRemove], and [didReplace].
class RouteNavigationObserver extends NavigatorObserver {
  /// A Route list for recording the navigation history.
  final List<Route<dynamic>> _routeHistory = [];

  Route get currentRoute => _routeHistory.last;

  String get _navigationHistoryString => '\n[${_routeHistory.map((route) => route.settings.name).join(' => ')}]';

  /// Returns true if [routeName] exists in the current navigation history; false otherwise.
  bool contains(String routeName) => _routeHistory.map((route) => route.settings.name).contains(routeName);

  /// Returns routes with [routeName] if found; empty list otherwise.
  List<Route> getRoutes(String routeName) => _routeHistory.where((route) => route.settings.name == routeName).toList();

  void _pop() {
    if (_routeHistory.isNotEmpty) {
      _routeHistory.removeLast();
    }
  }

  void _push(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // The push order isn't always the same as real route stack. For example, given initial route "/login_page" to
    // MaterialApp, the push order is "/login_page" and then "/". However, the order of real route stack is "/",
    // "/login_page". To align `_routeHistory` with the real route stack, we must add pushed route to the position
    // based on that of previousRoute.
    final index = previousRoute != null ? _routeHistory.indexOf(previousRoute) + 1 : 0;
    _routeHistory.insert(index, route);
  }

  void _remove(Route<dynamic> route) => _routeHistory.remove(route);

  void _replace(Route<dynamic>? newRoute, Route<dynamic>? oldRoute) {
    final index = (oldRoute != null && newRoute != null) ? _routeHistory.indexOf(oldRoute) : -1;
    if (index != -1) {
      _routeHistory
        ..removeAt(index)
        ..insert(index, newRoute!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _pop();
    _log(route, previousRoute, areaName: 'didPop');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _push(route, previousRoute);
    _log(route, previousRoute, areaName: 'didPush');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _remove(route);
    _log(route, previousRoute, areaName: 'didRemove');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _replace(newRoute, oldRoute);
    _log(newRoute, oldRoute, areaName: 'didReplace');
  }

  void _log(Route<dynamic>? route, Route<dynamic>? previousRoute, {required String areaName}) => debugLog(
        'route: ${route?.settings.name}, '
        'previousRoute: ${previousRoute?.settings.name}, '
        'navHistory: $_navigationHistoryString',
        name: '${(RouteNavigationObserver).toString()} $areaName',
      );
}
