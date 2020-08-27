import 'package:flutter/material.dart';

// ToDo: GETIT
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToRoute(Route route) {
    return navigatorKey.currentState.push(route);
  }

  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  // Future<dynamic> navigateToAndRemoveUntil(Route<Object> routeName, {Route<dynamic> route}) {
  //   return navigatorKey.currentState.pushAndRemoveUntil(routeName, (route) => false);
  // }

  maybePop() {
    navigatorKey.currentState.pop();
  }
}
