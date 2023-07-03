// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/users.dart';
import 'package:unicefapp/widgets/HomePage/EUM.dart';
import 'package:unicefapp/widgets/HomePage/PMV.dart';
import 'package:unicefapp/widgets/HomePage/Setting.dart';
import 'package:unicefapp/widgets/HomePage/SupplyLogistic.dart';
import 'package:unicefapp/widgets/Autres/SettingIP.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Acknowledge.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Dispatch.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Inventory.dart';
import 'package:unicefapp/widgets/SupplyLogistic/Trace.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/mydrawer.dart';

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
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Defaults.white,
          centerTitle: false,
          title: const Column(
            children: [
              Text(
                'Accueil',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Generic categories',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                'images/unicef1.png',
                width: 100.0,
                height: 100.0,
              ),
              onPressed: () {
                // Actions à effectuer lorsque le bouton est pressé
              },
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: Container(
        child: FutureBuilder<Agent?>(
          future: _futureAgentConnected,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user.roles.elementAt(0) == 'ROLE_ADMIN' ||
                      user.roles.elementAt(0) == 'ROLE_USER')
                    Expanded(
                        child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .65,
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
                    )),
                  if (user.roles.elementAt(0) == 'ROLE_IP')
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
                            child: Trace(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: settingsIP(context),
                          ),
                        ],
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Trackit EUM mobile application",
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
        ),
      ),
    );
  }
}
