import 'package:flutter/material.dart';
import 'package:servtecnico/prueba/servform.dart';
import 'package:servtecnico/src/providers/push_notifications_provider.dart';

//import 'package:servtecnico/pages/start.dart';
//import 'package:servtecnico/pages/login.dart';
//import 'package:servtecnico/pages/signin.dart';
import 'package:servtecnico/prueba/homeView.dart';
import 'package:servtecnico/prueba/welcomePage.dart';
import 'package:servtecnico/prueba/signup.dart';
import 'package:servtecnico/prueba/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final GlobalKey<NavigatorState> navigatorKey =
  // new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    final pushProvider = new PushNotificationsProvider();
    pushProvider.initNotifications();

    /*pushProvider.messages.listen((data) {
      //Navigator.pushNamed(context, routeName)
      print('Argumento del Push');
      print(data);

      navigatorKey.currentState.pushNamed('messages', arguments: data);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //navigatorKey: navigatorKey,
      title: 'Servicio Tecnico',
      initialRoute: 'loginPage',
      routes: {
        //new
        'welcome': (BuildContext context) => InitPage(),
        'loginPage': (BuildContext context) => LoginPage(),
        'signup': (BuildContext context) => SignUpPage(),
        'homeView': (BuildContext context) => HViewPage(),
        'servform': (BuildContext context) => FilterChipDisplay(),

        //Old
        //'start': (BuildContext context) => StartPage(),
        //'login': (BuildContext context) => LoginPage(),
        //'signin': (BuildContext context) => SignInPage(),
      },
    );
  }
}
