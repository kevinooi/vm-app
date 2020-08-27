import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:merchant_app/app_bloc/order_bloc.dart';
import 'package:merchant_app/navigation_service.dart';
import 'package:merchant_app/push_notifications.dart';
import 'package:merchant_app/screens/details/details_screen.dart';
import 'package:merchant_app/screens/home/home_screen.dart';
import 'package:merchant_app/screens/login_screen.dart';
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
  GetIt.I.registerLazySingleton(() => NavigationService());
  GetIt.I.registerLazySingleton(() => PushNotifications());
}

Map<String, PageRoute<dynamic> Function(Object)> routes = {
  Routes.root: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.root),
        builder: (context) => SplashScreen(),
      ),
  Routes.home: (Object params) => MaterialPageRoute(
        settings: RouteSettings(name: Routes.home),
        builder: (context) => HomeScreen(),
      ),
  Routes.logout: (Object params) => MaterialPageRoute(
      settings: RouteSettings(name: Routes.logout),
      builder: (context) => LoginPage()),
  Routes.detailScreen: (Object params) => MaterialPageRoute(
      settings: RouteSettings(name: Routes.detailScreen),
      builder: (context) => DetailsScreen()),
};

class Routes {
  Routes._();

  static const root = '/';
  static const home = '/home';
  static const logout = '/logout';
  static const detailScreen = '/detailScreen';
}

NavigationService get navigator => GetIt.I<NavigationService>();
PushNotifications get notification => GetIt.I<PushNotifications>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
                  builder: (context, child) {
                    return Navigator(
                      onGenerateRoute: (settings) =>
                          MaterialPageRoute(builder: (context) {
                        if (!notification.hasInit) {
                          notification.init(context);
                        }

                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: child,
                        );
                      }),
                    );
                  },
                  title: 'Merchant App',
                  theme: ThemeData(
                    scaffoldBackgroundColor: Color.fromRGBO(143, 148, 251, 1),
                    appBarTheme: AppBarTheme(
                        color: Color.fromRGBO(143, 148, 251, 1), elevation: 0),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  navigatorKey: navigator.navigatorKey,
                  initialRoute: Routes.root,
                  onGenerateRoute: (settings) {
                    return routes[settings.name](settings.arguments);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
