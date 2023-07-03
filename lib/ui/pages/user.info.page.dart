import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;

  @override
  void initState() {
    _futureAgentConnected = getAgent();
    _futureAgentConnected.then((value) => print(value));
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
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Defaults.bluePrincipal,
                  )),
            ],
          ),
          title: const Column(
            children: [
              Text(
                'User Information',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
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
                                ? '${snapshot.data!.lastname} ${snapshot.data!.firstname}'
                                : '',
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Defaults.black)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.hasData ? '${snapshot.data!.email}' : '',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        Text(
                            snapshot.hasData
                                ? '${snapshot.data!.telephone}'
                                : '',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        Text(snapshot.hasData ? '${snapshot.data!.roles}' : '',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
