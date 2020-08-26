import 'package:flutter/material.dart';
import 'package:merchant_app/app_bloc/user_bloc.dart';
import 'package:merchant_app/screens/home/home_screen.dart';
import 'package:merchant_app/screens/login_page.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // UserBloc get service => GetIt.I<UserBloc>();
  UserBloc userBloc;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // context.read<UserBloc>();

    if (userBloc?.hasInit ?? false) {
      print("splash");
      if (userBloc.jwt != null) {
        Future.delayed(Duration.zero, () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
        });
      } else {
        Future.delayed(Duration.zero, () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
        });
      }
    }
    print('bb');
  }

  @override
  Widget build(BuildContext context) {
    //setState called during build
    userBloc = context.watch<UserBloc>();
    return Container(
        color: Color.fromRGBO(143, 148, 251, .6),
        alignment: Alignment.center,
        child: CircularProgressIndicator());
  }
}
