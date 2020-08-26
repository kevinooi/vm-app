import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/user_bloc.dart';
import 'package:merchant_app/main.dart';
import 'package:merchant_app/navigation_service.dart';

// ToDo: GETIT
class PushNotifications {
  // PushNotifications._();

  // factory PushNotifications() => _instance;
  // static final PushNotifications _instance = PushNotifications._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // static UserBloc userBloc;
  UserBloc get userBloc => GetIt.I<UserBloc>();

  NavigationService get navigator => GetIt.I<NavigationService>();

  bool _initialized = false;

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
                      Navigator.pop(context);

                      navigator.navigateTo(Routes.home);
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
        // on received push notitications while app is in background
        onBackgroundMessage: backgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          try {
            if (message.containsKey('type')) {
              final dynamic data = message['type'];
              if (data == "new_deal") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onResume",
                  error: data,
                );

                // userBloc.hasNotifications = true;
                // userBloc.notificationRoute = Routes.tab;
                // userBloc.notificationArguments = "deals";
              }
            } else if (message.containsKey('data') &&
                message['data'].containsKey('type')) {
              final dynamic data = message['data']['type'];
              if (data == "new_deal") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onResume",
                  error: data,
                );

                // userBloc.hasNotifications = true;
                // userBloc.notificationRoute = Routes.tab;
                // userBloc.notificationArguments = "deals";
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
        onResume: (Map<String, dynamic> message) async {
          try {
            if (message.containsKey('type')) {
              final dynamic data = message['type'];
              if (data == "new_deal") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onResume",
                  error: data,
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
                message['data'].containsKey('type')) {
              final dynamic data = message['data']['type'];
              if (data == "new_deal") {
                developer.log(
                  "FCM",
                  name: "PushNotification.onResume",
                  error: data,
                );

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
      if (message.containsKey('type')) {
        final dynamic data = message['type'];
        if (data == "new_deal") {
          developer.log(
            "FCM",
            name: "PushNotification.backgroundMessageHandler",
            error: data,
          );

          // userBloc.hasNotifications = true;
          // userBloc.notificationRoute = Routes.tab;
          // userBloc.notificationArguments = "deals";
        }
      } else if (message.containsKey('data') &&
          message['data'].containsKey('type')) {
        final dynamic data = message['data']['type'];
        if (data == "new_deal") {
          developer.log(
            "FCM",
            name: "PushNotification.backgroundMessageHandler",
            error: data,
          );

          // userBloc.hasNotifications = true;
          // userBloc.notificationRoute = Routes.tab;
          // userBloc.notificationArguments = "deals";
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
}
