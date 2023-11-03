import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
// Importez le package upgrader

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool val1 = true;
  bool val2 = false;
  bool val3 = false;
  bool val4 = true;

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
      backgroundColor: Colors.grey[200],
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
                  color: Defaults.blueFondCadre,
                ),
              ),
            ],
          ),
          title: const Column(
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'User settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Account',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 600,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.5),
                      color: Defaults.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Icon(Icons.account_circle_rounded,
                                  size: 60, color: Defaults.black),
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
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Defaults.black)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          snapshot.hasData
                                              ? snapshot.data!.email
                                              : '',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                      Text(
                                          snapshot.hasData
                                              ? snapshot.data!.telephone
                                              : '',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                      Text(
                                          snapshot.hasData
                                              ? '${snapshot.data!.roles}'
                                              : '',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Preferences',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 600,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.5),
                      color: Defaults.white,
                    ),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              customSwitch(
                                'Remember Me',
                                val3,
                                (value) {
                                  setState(() {
                                    val3 = value;
                                  });
                                },
                              ),
                              customSwitch(
                                'Notifications',
                                val4,
                                (value) {
                                  setState(() {
                                    val4 = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(80.0),
                child: Text(
                  "Trackit EUM mobile application",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customSwitch(
  String texte,
  bool val,
  Function onChangeMethode, {
  Function? onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          texte,
          style: const TextStyle(
            color: Defaults.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        CupertinoSwitch(
          value: val,
          onChanged: (value) {
            onChangeMethode(value);
            if (onPressed != null) {
              onPressed();
            }
          },
          trackColor: Colors.grey,
          activeColor: Defaults.bluePrincipal,
        ),
      ],
    ),
  );
}
