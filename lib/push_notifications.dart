import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/order_services.dart';
import 'package:merchant_app/app_bloc/user_bloc.dart';
import 'package:merchant_app/main.dart';
import 'package:merchant_app/navigation_service.dart';

import 'app_bloc/order_bloc.dart';
import 'models/order.dart';

class PushNotifications with ChangeNotifier {
  // PushNotifications._();

  // factory PushNotifications() => _instance;
  // static final PushNotifications _instance = PushNotifications._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  NavigationService get navigator => GetIt.I<NavigationService>();
  UserBloc get userBloc => GetIt.I<UserBloc>();
  OrderBloc orderBloc;
  OrderServices get orderService => GetIt.I<OrderServices>();
  bool _initialized = false;
  bool hasInit = false;

  Future<Order> futureOrder;
  String _id;
  String get id => _id;
  set id(String id) {
    _id = id;
    futureOrder = orderService.getOrder(id);
    notifyListeners();
  }

  String notifyId;

  Future<void> init(BuildContext context) async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        // on received push notitications while app is in foreground
        onMessage: (Map<String, dynamic> message) async {
          developer.log(
            "FCM",
            name: "PushNotification.onMessage",
            error: message,
          );

          try {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message['notification']['title']),
                    Text(message['notification']['body']),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      // future
                      // message['notification']['body'] == order_id
                      // orderService.getOrder(order_id)

                      // ToDo
                      // refresh order || get this order
                      // orderService.getAllOrders()
                      orderService.getAllOrders();
                      Navigator.pop(context);
                      if (message.containsKey('data') &&
                          message['data'].containsKey('view') &&
                          message['data'].containsKey('order_id')) {
                        final dynamic view = message['data']['view'];
                        final dynamic orderId = message['data']['order_id'];

                        if (view != null) {
                          // Navigate to the new order view
                          if (view == 'new_order') {
                            id = orderId;
                            notifyId = id;
                            navigator.navigateTo(Routes.detailScreen);
                          }
                        }
                      }
                      // navigator.navigateTo(Routes.home);
                    },
                  ),
                ],
              ),
            );
          } catch (error) {
            developer.log(
              "FCM",
              name: "PushNotification.error",
              error: error?.toString(),
            );
          }
        },
        // ToDo: fix navigation when tapping on notification
        // on received push notitications while app is killed
        onBackgroundMessage: backgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          try {
            if (message.containsKey('view') &&
                message.containsKey('order_id')) {
              final dynamic view = message['view'];
              final dynamic orderId = message['order_id'];
              if (view == "new_order") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onLaunch",
                  error: view,
                );

                if (view != null) {
                  // Navigate to the new order view
                  if (view == 'new_order') {
                    id = orderId;
                    notifyId = id;
                    navigator.navigateTo(Routes.detailScreen);
                  }
                }
              }
            } else if (message.containsKey('data') &&
                message['data'].containsKey('view') &&
                message['data'].containsKey('order_id')) {
              // navigator.navigateTo(Routes.detailScreen);
              // navigator.navigateToRoute(MaterialPageRoute(builder: (context) => DetailsScreen()));
              final dynamic view = message['data']['view'];
              final dynamic orderId = message['data']['order_id'];
              if (view == "new_order") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onLaunch",
                  error: view,
                );

                if (view != null) {
                  // Navigate to the new order view
                  if (view == 'new_order') {
                    id = orderId;
                    notifyId = id;
                    navigator.navigateTo(Routes.detailScreen);
                  }
                }
              }
            }
          } catch (error) {
            print(error);
          }

          developer.log(
            "FCM",
            name: "PushNotification.onLaunch",
            error: message,
          );
        },
        // on received push notitications while app is in background
        onResume: (Map<String, dynamic> message) async {
          try {
            if (message.containsKey('view')) {
              final dynamic view = message['view'];
              // final dynamic orderId = message['order_id'];
              if (view == "new_order") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onResume",
                  error: view,
                );
                // Future.microtask(
                //   () => userBloc.navigationService.navigateToRoute(
                //     MaterialPageRoute(
                //       builder: (context) => HomeScreen(),
                //     ),
                //   ),
                // );
              }
            } else if (message.containsKey('data') &&
                message['data'].containsKey('view') &&
                message['data'].containsKey('order_id')) {
              final dynamic view = message['data']['view'];
              final String orderId = message['data']['order_id'];
              if (view == "new_order") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onResume",
                  error: view,
                );
                // userBloc.hasNotifications = true;
                // userBloc.notificationRoute = Routes.detailScreen;
                if (view != null) {
                  // Navigate to the new order view
                  if (view == 'new_order') {
                    id = orderId;
                    notifyId = id;
                    navigator.navigateTo(Routes.detailScreen);
                  }
                }
                // if (userBloc.hasNotifications) {
                //   String route;
                //   route = userBloc.notificationRoute ?? Routes.home;
                //   Future.delayed(Duration.zero, () {
                //     orderBloc.id = userBloc.notificationArguments;
                //     // Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
                //     navigator.navigateTo(Routes.detailScreen);
                //   });
                // }

                // Future.microtask(
                //   () => userBloc.navigationService.navigateTo(
                //     // Routes.tab,
                //     "Home",
                //     arguments: "deals",
                //   ),
                // );
              }
            }
          } catch (error) {
            print(error);
          }

          developer.log(
            "FCM",
            name: "PushNotification.onResume",
            error: message,
          );
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      developer.log("FCM", name: "PushNotification.token", error: token);
      // print("FirebaseMessaging token: $token");

      userBloc.fcmToken = token;
      _initialized = true;
    }
  }

  static Future<dynamic> backgroundMessageHandler(
      Map<String, dynamic> message) async {
    try {
      if (message.containsKey('view')) {
        final dynamic view = message['view'];
        // final dynamic orderId = message['order_id'];
        if (view == "detail_screen") {
          developer.log(
            "FCM",
            name: "PushNotification.backgroundMessageHandler",
            error: view,
          );
        }
      } else if (message.containsKey('data') &&
          message['data'].containsKey('view') &&
          message['data'].containsKey('order_id')) {
        final dynamic view = message['data']['view'];
        // final dynamic orderId = message['data']['order_id'];
        if (view == "new_order") {
          developer.log(
            "FCM",
            name: "PushNotification.backgroundMessageHandler",
            error: view,
          );

          // if (view != null) {
          //   if (view == 'new_order') {
          //     id = orderId;
          //     notifyId = id;
          // navigator.navigateTo(Routes.detailScreen);
          //   }
          // }
        }
      }
    } catch (error) {
      print(error);
    }

    developer.log(
      "FCM",
      name: "PushNotification.backgroundMessageHandler",
      error: message,
    );
  }

  //  void _serialiseAndNavigate(Map<String, dynamic> message) {
  //   var notificationData = message['data'];
  //   var view = notificationData['view'];

  //   if (view != null) {
  //     // Navigate to the create post view
  //     if (view == 'detail_screen') {
  //       navigator.navigateTo(Routes.detailScreen);
  //     }
  //     if (view == 'home_screen') {
  //       navigator.navigateTo(Routes.home);
  //     }
  //     // If there's no view it'll just open the app on the first view
  //   }
  // }
}
