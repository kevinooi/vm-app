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

  Future<dynamic> maybePop() {
    return navigatorKey.currentState.maybePop();
  }
}
