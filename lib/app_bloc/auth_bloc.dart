import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:merchant_app/app_bloc/user_bloc.dart';
import 'package:merchant_app/models/graphQLConf.dart';

import 'auth_service.dart';

class AuthBloc with ChangeNotifier{

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  AuthServices get service => GetIt.I<AuthServices>();
  AuthBloc(this.userBloc);
  UserBloc userBloc;
  // UserBloc get userBloc => _userBloc;
  // set userBloc(UserBloc userBloc) {
  //   _userBloc = userBloc;
  // }

  Future loginFlow(String jwt) async {
    await userBloc.setJwt(jwt);
  }
  // final error = service.login
}
