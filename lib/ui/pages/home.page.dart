import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/users.dart';
import 'package:unicefapp/widgets/Autres/Acknow.dart';
import 'package:unicefapp/widgets/Autres/SettingIP.dart';
import 'package:unicefapp/widgets/HomePage/EUM.dart';
import 'package:unicefapp/widgets/HomePage/PMV.dart';
import 'package:unicefapp/widgets/HomePage/Setting.dart';
import 'package:unicefapp/widgets/HomePage/SupplyLogistic.dart';
import 'package:unicefapp/widgets/HomePage/Acknowledge.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Dispatch.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Inventory.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/mydrawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = locator<TokenStorageService>();
  late Future<Agent?> _futureAgentConnected;
  bool ligth = true;
  late Future<User> userFuture;
  bool hasInternet = false;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    super.initState();
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.blueFondCadre,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Defaults.white,
          centerTitle: false,
          title: Row(
            children: [
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.accueil,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      FutureBuilder<Agent?>(
                        future: _futureAgentConnected,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(
                                '${AppLocalizations.of(context)!.error} ${snapshot.error}');
                          } else {
                            final user = snapshot.data!;
                            return Row(
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.welcomeTo} ${user.country}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Image.asset(
                                  'images/${user.country}.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return FutureBuilder<Agent?>(
              future: _futureAgentConnected,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                      '${AppLocalizations.of(context)!.error} ${snapshot.error}');
                } else {
                  final user = snapshot.data!;

                  print('Role: ${user.roles.elementAt(0)}');
                  print('Country: ${user.country}');

                  // ---------------  O N L I N E         M E N U -------------------------
                  // --------------                                 ---------------------------

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //////------- MENU ADMIN  &&  USER  -------//////////
                      ///
                      if ((user.roles.elementAt(0) == 'ROLE_ADMIN') &&
                          user.country == 'GUINEA BISSAU')
                        ((Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .60,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: supplyLogistic(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PMV(context),
                              ),
                            ],
                          ),
                        )))
                      else if (user.country == 'NIGERIA' &&
                          user.roles.elementAt(0) == 'ROLE_ADMIN')
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .60,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PMV(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: supplyLogistic(context),
                              ),
                            ],
                          ),
                        )
                      else if (user.country == 'CHAD' &&
                          user.roles.elementAt(0) == 'ROLE_ADMIN')
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .60,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: supplyLogistic(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PMV(context),
                              ),
                            ],
                          ),
                        ),

                      //////------- MENU  USER  -------//////////
                      ///

                      if (user.roles.elementAt(0) == 'ROLE_USER' &&
                          user.country == 'GUINEA BISSAU')
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .60,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: supplyLogistic(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                            ],
                          ),
                        )
                      else if (user.country == 'NIGERIA' &&
                          user.roles.elementAt(0) == 'ROLE_USER')
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .60,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: supplyLogistic(context),
                              ),
                            ],
                          ),
                        )
                      else if (user.country == 'CHAD' &&
                          user.roles.elementAt(0) == 'ROLE_USER')
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .60,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: supplyLogistic(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                            ],
                          ),
                        )

                      //////------- MENU IP -------//////////
                      ///
                      else if (user.roles.elementAt(0) == 'ROLE_IP' &&
                          (user.country == 'NIGERIA'))
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .85,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Acknow(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Inventory(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Dispatch(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: settingsIP(context),
                              ),
                            ],
                          ),
                        )
                      else if (user.roles.elementAt(0) == 'ROLE_IP' &&
                          (user.country == 'CHAD'))
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .85,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Acknow(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Inventory(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Dispatch(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: settingsIP(context),
                              ),
                            ],
                          ),
                        )
                      else if (user.roles.elementAt(0) == 'ROLE_IP' &&
                          (user.country == 'GUINEA BISSAU'))
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .85,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Acknow(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Inventory(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Dispatch(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: settingsIP(context),
                              ),
                            ],
                          ),
                        )

                      //////------- MENU SURVEYOR -------//////////
                      ///
                      else if (user.roles.elementAt(0) == 'ROLE_SURVEYOR' &&
                          (user.country == 'NIGERIA'))
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .65,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                            ],
                          ),
                        )
                      else if (user.roles.elementAt(0) == 'ROLE_SURVEYOR' &&
                          (user.country == 'CHAD'))
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .65,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                            ],
                          ),
                        )
                      else if (user.roles.elementAt(0) == 'ROLE_SURVEYOR' &&
                          (user.country == 'GUINEA BISSAU'))
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .65,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                            ],
                          ),
                        )

                      //////------- MENU SUPPLIER -------//////////
                      ///
                      /*else if (user.roles.elementAt(0) == 'ROLE_SUPPLIER' &&
                              user.country == 'NIGERIA' ||
                          user.country == 'CHAD' ||
                          user.country == 'GUINEA BISSAU')
                        AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.error,
                            textAlign: TextAlign.center,
                          ),
                          content: SizedBox(
                            height: 150,
                            child: Column(
                              children: [
                                Lottie.asset(
                                  'animations/access_denied.json',
                                  repeat: true,
                                  reverse: true,
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.accessDenied,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  exit(0);
                                },
                                child: Text(AppLocalizations.of(context)!.ok))
                          ],
                        ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Trackit EUM Mobile Application",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),*/
                    ],
                  );
                }
              },
            );

            // ---------------  O F F L I N E         M E N U -------------------------
            // --------------                                 ---------------------------
          } else {
            return FutureBuilder<Agent?>(
              future: _futureAgentConnected,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                      '${AppLocalizations.of(context)!.error} ${snapshot.error}');
                } else {
                  final user = snapshot.data;
                  Widget menuWidget =
                      Acknow(context); // Initialisation par défaut
                  if ((user?.country == 'NIGERIA' ||
                      user?.country == 'CHAD' ||
                      user?.country == 'GUINEA BISSAU')) {
                    if (user?.roles.elementAt(0) == 'ROLE_ADMIN') {
                      menuWidget = EUM(context);
                    } else if (user?.roles.elementAt(0) == 'ROLE_IP') {
                      menuWidget = Acknow(context);
                    } else if (user?.roles.elementAt(0) == 'ROLE_SURVEYOR') {
                      menuWidget = EUM(context);
                    }
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio:
                              .65, // Ajustez cela selon vos besoins
                          crossAxisSpacing: 5,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: menuWidget,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Trackit EUM Mobile Application",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
