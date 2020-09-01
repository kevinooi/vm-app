import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:merchant_app/models/graphQLConf.dart';
import 'package:merchant_app/models/graphql_query.dart';
import 'package:merchant_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc with ChangeNotifier {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  UserBloc() {
    init();
    print('init');
  }
  SharedPreferences preferences;

  User _user;
  User get user => _user;
  set user(User user) {
    _user = user;

    log(
      'user',
      name: "UserBloc.user",
      error: user?.toJson().toString(),
    );
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  set loggedIn(bool status) {
    _loggedIn = status;
    notifyListeners();
  }

  // ToDo: send to device
  String fcmToken;
  // PushNotification service
  bool hasNotifications = false;
  String notificationRoute;
  String notificationArguments;

  String _jwt;
  String get jwt => _jwt;
  setJwt(String jwt) async {
    _jwt = jwt;

    log(
      'jwt',
      name: "UserBloc.jwt",
      error: jwt,
    );

    Link _link;

    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    if (jwt == null) {
      //debug preferences is null after reset
      await preferences?.remove("jwt");

      // await appBloc.storage.delete(key: 'jwt');
      _link = HttpLink(uri: "${GraphQLConfiguration.baseURL}/graphql");
    } else {
      var status = await preferences.setString('jwt', jwt);
      if (status == false) {
        //handle if save failed
        print("failed");
      }
      // await appBloc.storage.write(key: 'jwt', value: jwt);
      final AuthLink _authLink = AuthLink(
        getToken: () => 'Bearer $jwt',
      );
      _link = _authLink.concat(GraphQLConfiguration.httpLink);
    }
    GraphQLConfiguration.link = _link;
    // GraphQLConfiguration. =  ValueNotifier(GraphQLClient(
    //   cache: InMemoryCache(),
    //   link: _link,
    // ));

    notifyListeners();
  }

  bool hasInit = false;

  init() async {
    try {
      preferences = await SharedPreferences.getInstance();
      var savedJwt = preferences.getString('jwt');
      if (savedJwt != null) {
        setJwt(savedJwt);
      }
      // var status = await preferences.setString('jwt', jwt);
      // if (status == false) {
      //   //handle if save failed
      // }
      hasInit = true;
      notifyListeners();
      print("aa");
    } catch (error) {
      hasInit = true;
      notifyListeners();
      log(
        "init",
        name: "UserBloc.init",
        error: error?.toString(),
      );

      return error;
    }
  }

  Future<dynamic> logout() async {
    try {
      user = null;
      await setJwt(null);

      // await appBloc.storage.deleteAll();
      // await appBloc.storage.write(key: "welcomed", value: "true");

      loggedIn = false;
    } catch (error) {
      log(
        "logout",
        name: "UserBloc.logout",
        error: error,
      );

      return error;
    }

    return true;
  }

  Future<User> getMyself(String id) async {
    try {
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.query(QueryOptions(
        documentNode: gql(GraphQLQuery.getMyself),
        variables: {
          "id": id,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        log(
          'getMyself',
          name: "UserBloc",
          error: result.exception,
        );
        throw "error";
      }

      final jsonorder = result.data["user"] as Map<String, dynamic>;
      return User.fromJson(jsonorder);
    } catch (error) {
      log(
        'getMyself',
        name: "UserBloc",
        error: error,
      );
    }
    return null;
  }
}

showSnackBar(BuildContext context, String error) {
  final snackBar = SnackBar(content: Text(error));
  Scaffold.of(context).showSnackBar(snackBar);
}
