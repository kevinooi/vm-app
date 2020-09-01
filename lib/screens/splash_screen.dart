import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/order_bloc.dart';
import 'package:merchant_app/app_bloc/user_bloc.dart';
import 'package:merchant_app/main.dart';
import 'package:merchant_app/push_notifications.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // UserBloc get service => GetIt.I<UserBloc>();
  UserBloc userBloc;
  OrderBloc orderBloc;
  PushNotifications get notification => GetIt.I<PushNotifications>();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    
    if (userBloc?.hasInit ?? false) {
      print("splash");
      if (userBloc.jwt != null) {
        String route = Routes.home;
        Future.delayed(Duration.zero, () {
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        });
      } else {
        String route = Routes.logout;
        Future.delayed(Duration.zero, () {
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = context.watch<UserBloc>();
    return Container(
        color: Color.fromRGBO(143, 148, 251, .6),
        alignment: Alignment.center,
        child: CircularProgressIndicator());
  }
}
