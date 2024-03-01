import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

var indexClicked = 0;

class _MyDrawerState extends State<MyDrawer> {
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;
  late bool _isInternetConnected = false;

  double drawerMaxWidth = 250.0;
  double drawerHeaderWidth = 200.0;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => print(value));

    _checkInternetConnectivity().then((isConnected) {
      setState(() {
        _isInternetConnected = isConnected;
      });
    });

    super.initState();
  }

  Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Future<Agent?> getAgent() async {
    return await storage.retrieveAgentConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
              padding:
                  const EdgeInsets.only(left: 0, top: 10, bottom: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.account_circle_rounded,
                          size: 84, color: Defaults.black),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder<Agent?>(
                          future: _futureAgentConnected,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Text(
                                    snapshot.hasData
                                        ? '${snapshot.data!.lastname.split(" ").take(2).join(" ")} ${snapshot.data!.firstname}'
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: Defaults.black)),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          })
                    ],
                  ),
                ],
              )),
          const Divider(
            height: 10,
            color: Defaults.black,
            indent: 10,
            endIndent: 10,
          ),
          FutureBuilder<Agent?>(
            future: _futureAgentConnected,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final user = snapshot.data!;
                final role = user.roles.isNotEmpty ? user.roles[0] : null;
                // Utilisez des conditions pour afficher les éléments du Drawer en fonction du rôle de l'agent
                if (role == 'ROLE_ADMIN') {
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: const [
                        AppDrawerTile(
                          index: 0,
                          route: '/home',
                        ),
                        AppDrawerTile(
                          index: 1,
                          route: '/acknowledge',
                        ),
                        AppDrawerTile(
                          index: 2,
                          route: '/inventory',
                        ),
                        AppDrawerTile(
                          index: 3,
                          route: '/setting',
                        ),
                        // AppDrawerTile(
                        //   index: 4,
                        //   route: '/report',
                        // ),
                      ],
                    ),
                  );
                } else if (role == 'ROLE_USER') {
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: const [
                        AppDrawerTile(
                          index: 0,
                          route: '/home',
                        ),
                        AppDrawerTile(
                          index: 1,
                          route: '/acknowledge',
                        ),
                        AppDrawerTile(
                          index: 2,
                          route: '/inventory',
                        ),
                        AppDrawerTile(
                          index: 3,
                          route: '/setting',
                        ),
                        // AppDrawerTile(
                        //   index: 4,
                        //   route: '/report',
                        // ),
                      ],
                    ),
                  );
                } else if (role == 'ROLE_SURVEYOR') {
                  if (_isInternetConnected) {
                    return Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: const [
                          AppDrawerTile(
                            index: 0,
                            route: '/eum',
                          ),
                          AppDrawerTile(
                            index: 1,
                            route: '/setting',
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: const [
                          AppDrawerTile(
                            index: 0,
                            route: '/eum',
                          ),
                        ],
                      ),
                    );
                  }
                }
                if (role == 'ROLE_IP') {
                  if (_isInternetConnected) {
                    return Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: const [
                          AppDrawerTile(
                            index: 1,
                            route: '/acknowledge',
                          ),
                          AppDrawerTile(
                            index: 2,
                            route: '/inventory',
                          ),
                          AppDrawerTile(
                            index: 3,
                            route: '/setting',
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView(
                        children: [
                          AppDrawerTile(
                            index: 1,
                            route: '/acknowledgeCopy',
                          ),
                        ],
                      ),
                    ); // Affiche un conteneur vide si pas d'internet
                  }
                } else {
                  // Cas par défaut ou rôle non reconnu
                  return Container(
                    child: Text('Role not recognized'),
                  );
                }
              }
            },
          ),
          const Divider(
            height: 10,
            color: Defaults.black,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20, left: 0.0, right: 110.0, top: 10),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.error_outline,
                size: 30.0,
                color: Defaults.black,
              ),
              label: Text(
                AppLocalizations.of(context)!.about,
                style: TextStyle(
                  fontSize: 18,
                  color: Defaults.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 140, left: 0.0, right: 110.0, top: 10),
            child: TextButton.icon(
              onPressed: () {
                exit(0);
              },
              icon: const Icon(
                Icons.logout,
                size: 30.0,
                color: Defaults.black,
              ),
              label: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  fontSize: 18,
                  color: Defaults.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//

class AppDrawerDivider extends StatelessWidget {
  const AppDrawerDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Defaults.drawerItemColor,
      indent: 3,
      endIndent: 3,
    );
  }
}

class AppDrawerTile extends StatefulWidget {
  const AppDrawerTile({Key? key, required this.index, required this.route})
      : super(key: key);

  final int index;
  final String route;

  @override
  State<AppDrawerTile> createState() => _AppDrawerTileState();
}

class _AppDrawerTileState extends State<AppDrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        onTap: () {
          setState(() {
            indexClicked = widget.index;
          });
          Navigator.of(context).pop();
          Navigator.pushNamed(context, widget.route);
        },
        selected: indexClicked == widget.index,
        selectedTileColor: Defaults.drawerSelectedTileColor,
        leading: Icon(
          Defaults.drawerItemIcon[widget.index],
          size: 30,
          color: indexClicked == widget.index
              ? Defaults.drawerItemSelectedColor
              : Defaults.drawerItemColor,
        ),
        title: Text(
          Defaults.drawerItemText[widget.index],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: indexClicked == widget.index
                ? Defaults.drawerItemSelectedColor
                : Defaults.black,
          ),
        ),
      ),
    );
  }
}
