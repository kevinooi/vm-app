import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:merchant_app/app_bloc/order_bloc.dart';
import 'package:merchant_app/screens/login_page.dart';
import 'package:merchant_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'app_bloc/auth_bloc.dart';
import 'app_bloc/auth_service.dart';
import 'app_bloc/order_services.dart';
import 'app_bloc/user_bloc.dart';
import 'models/graphQLConf.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void setupLocator() {
  GetIt.I.registerLazySingleton(() => OrderServices());
  GetIt.I.registerLazySingleton(() => AuthServices());
  GetIt.I.registerLazySingleton(() => AuthBloc(UserBloc()));
  GetIt.I.registerLazySingleton(() => UserBloc());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
      runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserBloc>(
      create: (context) => UserBloc(),
      child: Consumer<UserBloc>(
        builder: (context, bloc, widget) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthBloc>(
                create: (context) => AuthBloc(bloc),
              ),
              ChangeNotifierProvider<OrderBloc>(
                create: (context) => OrderBloc(),
              )
            ],
            child: GraphQLProvider(
              client: graphQLConfiguration.client,
              child: CacheProvider(
                child: MaterialApp(
                    title: 'Merchant App',
                    theme: ThemeData(
                      scaffoldBackgroundColor: Color.fromRGBO(143, 148, 251, 1),
                      appBarTheme: AppBarTheme(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          elevation: 0),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
                    home: SplashScreen(),
                    routes: {
                      "/logout": (_) => new LoginPage(),
                      // "/HomeScreen": (_) => new HomeScreen()
                    }),
              ),
            ),
          );
        },
      ),
    );
  }
}
