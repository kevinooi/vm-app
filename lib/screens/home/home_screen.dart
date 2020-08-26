import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/user_bloc.dart';
import 'package:merchant_app/models/graphQLConf.dart';
import 'package:merchant_app/screens/login_page.dart';
// import 'package:provider/provider.dart';

import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  UserBloc get service => GetIt.I<UserBloc>();

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Log Out?'),
            content: new Text('Are you sure you want to log out?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  service.logout();
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
                  });
                },
                child: new Text('Yes'),
              ),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // print(context.select<AuthBloc, bool>((value) => value.userBloc.loggedIn));

    return
        // WillPopScope(
        //   onWillPop: () => Future.value(false),
        //   child:
        Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Orders', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Future.delayed(
                Duration.zero,
                () {
                  _showDialog();
                },
              );
            },
          ),
        ],
        leading: new Container(),
      ),
      body: Body(),
    );
  }
}
