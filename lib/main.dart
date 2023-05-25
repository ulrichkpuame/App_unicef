// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unicefapp/widgets/navigator_key.dart';
import 'di/service_locator.dart';
import 'ui/pages/home.page.dart';
import 'ui/pages/login.page.dart';
import 'widgets/default.colors.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = DevHttpOverrides();
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => const HomePage(),
      },
      title: 'Unicef App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Defaults.primaryBleuColor,
      ),
      initialRoute: '/',
    );
  }
}
