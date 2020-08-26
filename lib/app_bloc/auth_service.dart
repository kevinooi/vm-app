import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:merchant_app/models/graphQLConf.dart';

import 'auth_bloc.dart';

class AuthServices with ChangeNotifier {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  AuthBloc get service => GetIt.I<AuthBloc>();

  bool _isLocalLoading = false;

  bool get isLocalLoading => _isLocalLoading;
  set isLocalLoading(bool isLocalLoading) {
    _isLocalLoading = isLocalLoading;
    notifyListeners();
  }

  Future<dynamic> login(String identifier, String password) async {
    print(identifier);
    print(password);

    isLocalLoading = true;

    try {
      final loginResponse = await http.post(
        '${GraphQLConfiguration.baseURL}/auth/local',
        body: {
          'identifier': identifier,
          'password': password,
        },
      );

      if (loginResponse.statusCode != 200) {
        print(loginResponse);

        // switch (loginResponse.statusCode) {
        //   case 400:
        //   case 401:
        //   case 403:
        //     throw getHttpException(loginResponse.body);
        //   case 500:
        //     throw "500";
        //   default:
        throw "error";
      }

      final Map<String, dynamic> response = json.decode(loginResponse.body);

      if (response.isEmpty) {
        throw 'error';
      }

      print(response);

      if (response['jwt'] == null || (response['jwt'] as String).isEmpty) {
        throw "error";
      }

      if (response['user'] == null) {
        throw "error";
      }

      await service.loginFlow(response['jwt']);
      isLocalLoading = false;

      return null;
    } catch (error) {
      log(
        "login",
        name: "AuthHttpApi.login",
        error: error?.toString(),
      );

      isLocalLoading = false;

      return error;
    }
  }
}
