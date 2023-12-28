import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/users.dart';
import 'package:unicefapp/widgets/Autres/SettingIP.dart';
import 'package:unicefapp/widgets/HomePage/EUM.Offline.dart';
import 'package:unicefapp/widgets/HomePage/EUM.dart';
import 'package:unicefapp/widgets/HomePage/PMV.dart';
import 'package:unicefapp/widgets/HomePage/Setting.dart';
import 'package:unicefapp/widgets/HomePage/SupplyLogistic.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Acknowledge.dart';
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
                      fontSize: 25,
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //////------- MENU ADMIN -------//////////
                      ///
                      if ((user.roles.elementAt(0) == 'ROLE_ADMIN' ||
                              user.roles.elementAt(0) == 'ROLE_USER') &&
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: settings(context),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: settings(context),
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
                                child: settings(context),
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
                                child: Acknowledge(context),
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
                                child: Acknowledge(context),
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
                                child: Acknowledge(context),
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (user?.roles.elementAt(0) == 'ROLE_ADMIN' &&
                          user?.country == 'NIGERIA')
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .65,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Acknowledge(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EUM(context),
                              ),
                            ],
                          ),
                        )
                      else if (user?.roles.elementAt(0) == 'ROLE_IP' &&
                          (user?.country == 'NIGERIA' ||
                              user?.country == 'CHAD' ||
                              user?.country == 'GUINEA BISSAU'))
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .85,
                            crossAxisSpacing: 5,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Acknowledge(context),
                              ),
                            ],
                          ),
                        )
                      else if (user?.roles.elementAt(0) == 'ROLE_SURVEYOR' &&
                          (user?.country == 'NIGERIA' ||
                              user?.country == 'CHAD' ||
                              user?.country == 'GUINEA BISSAU'))
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
