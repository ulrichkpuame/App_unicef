// ignore_for_file: unused_import
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicefapp/l10n/l10n.dart';
import 'package:unicefapp/provider/locale_provider.dart';
import 'package:unicefapp/ui/pages/Acknowledge/acknowledge.page%20copy.dart';
import 'package:unicefapp/ui/pages/EUM/eum.page.copy.dart';
import 'package:unicefapp/ui/pages/S&L.page.dart';
import 'package:unicefapp/ui/pages/Acknowledge/acknowledge.page.dart';
import 'package:unicefapp/ui/pages/country.page.dart';
import 'package:unicefapp/ui/pages/inventory.page.dart';
import 'package:unicefapp/ui/pages/issues.page.dart';
import 'package:unicefapp/ui/pages/report.page.dart';
import 'package:unicefapp/ui/pages/setting.page.dart';
import 'package:unicefapp/ui/pages/transfer.page.dart';
import 'package:unicefapp/widgets/navigator_key.dart';
import 'package:upgrader/upgrader.dart';
import 'di/service_locator.dart';
import 'ui/pages/home.page.dart';
import 'ui/pages/login.page.dart';
import 'widgets/default.colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

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

bool _isBackPressedOnce =
    false; // Déclaration de la variable pour suivre l'état du bouton retour

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          return UpgradeAlert(
            upgrader: Upgrader(
              canDismissDialog: true,
              dialogStyle: UpgradeDialogStyle.cupertino,
            ),
            child: OverlaySupport.global(
              child: WillPopScope(
                // Fonction onWillPop pour gérer le bouton retour
                onWillPop: () async {
                  // Empêche le retour si une transition est en cours
                  if (Navigator.of(context).userGestureInProgress) return false;

                  // Gère le double appui sur le bouton retour
                  if (_isBackPressedOnce) {
                    // Si le bouton retour est pressé une deuxième fois, ferme l'application
                    return true;
                  } else {
                    // Si le bouton retour est pressé pour la première fois, affiche le message
                    _isBackPressedOnce = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Appuyez une seconde fois pour quitter')),
                    );
                    // Réinitialise le booléen après 2 secondes
                    Timer(Duration(seconds: 2), () {
                      _isBackPressedOnce = false;
                    });
                    return false; // Empêche la fermeture de l'application
                  }
                },
                child: MaterialApp(
                  locale: provider.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: L10n.all,
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
                    '/acknowledgeCopy': (context) =>
                        const AcknowledgePageCopy(),
                    '/report': (context) => ReportDataPage(),
                    '/eum': ((context) => const EUMPageCopy()),
                  },
                  title: 'Unicef App',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    fontFamily: 'Roboto',
                    primarySwatch: Defaults.primaryBleuColor,
                  ),
                  initialRoute: '/',
                ),
              ),
            ),
          );
        },
      );
}
