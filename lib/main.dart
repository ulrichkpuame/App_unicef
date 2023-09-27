// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/acknowledge.page.dart';
import 'package:unicefapp/ui/pages/inventory.page.dart';
import 'package:unicefapp/ui/pages/issues.page.dart';
import 'package:unicefapp/ui/pages/setting.page.dart';
import 'package:unicefapp/ui/pages/transfer.page.dart';
import 'package:unicefapp/widgets/navigator_key.dart';
import 'package:upgrader/upgrader.dart';
import 'di/service_locator.dart';
import 'ui/pages/home.page.dart';
import 'ui/pages/login.page.dart';
import 'widgets/default.colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  await Upgrader.clearSavedSettings();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        canDismissDialog: true,
        dialogStyle: UpgradeDialogStyle.cupertino,
      ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/S&L': (context) => const SupplyLogisticPage(),
          '/transaction': (context) => const TransactionPage(),
          '/setting': (context) => const SettingPage(),
          '/issue': (context) => const IssuesPage(),
          '/inventory': (context) => const InventoryPage(),
          '/acknowledge': (context) => const AcknowledgePage(),
        },
        title: 'Unicef App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Defaults.primaryBleuColor,
        ),
        initialRoute: '/',
      ),
    );
  }
}
