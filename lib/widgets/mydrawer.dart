import 'package:flutter/material.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/ui/pages/login.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

var indexClicked = 0;

class _MyDrawerState extends State<MyDrawer> {
  final storage = locator<TokenStorageService>();
  late final Future<Agent?> _futureAgentConnected;

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
    return Drawer(
      backgroundColor: Defaults.blueFondCadre,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Defaults.greenPrincipal,
              ),
              padding:
                  const EdgeInsets.only(left: 0, top: 10, bottom: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.account_circle_rounded,
                          size: 59, color: Colors.white),
                      const SizedBox(
                        height: 10,
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
                                        color: Defaults.bluePrincipal)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    snapshot.hasData
                                        ? '${snapshot.data!.roles}'
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ],
                            );
                          })
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     IconButton(
                  //         onPressed: () {
                  //           storage.deleteAllToken();
                  //           indexClicked = 0;
                  //           Navigator.of(context).pop();
                  //           Navigator.push(context,
                  //               MaterialPageRoute(builder: (_) => LoginPage()));
                  //         },
                  //         icon: const Icon(Icons.power_settings_new_rounded),
                  //         color: Defaults.bluePrincipal),
                  //   ],
                  // )
                ],
              )),
          Expanded(
            child: ListView(padding: EdgeInsets.zero, children: const [
              AppDrawerTile(
                index: 0,
                route: '',
              ),
              AppDrawerTile(
                index: 1,
                route: '',
              ),
              AppDrawerTile(
                index: 2,
                route: '',
              ),
              AppDrawerTile(
                index: 3,
                route: '',
              ),
              AppDrawerTile(
                index: 4,
                route: '',
              ),
              AppDrawerTile(
                index: 5,
                route: '',
              ),
              AppDrawerTile(
                index: 6,
                route: '',
              ),
              AppDrawerTile(
                index: 7,
                route: '',
              ),
            ]),
          ),

          const Divider(
            height: 30,
            color: Defaults.bluePrincipal,
            indent: 10,
            endIndent: 10,
          ),

          // Padding(
          //   padding: const EdgeInsets.only(
          //       left: 0.0, right: 110.0, top: 10, bottom: 140),
          //   child: TextButton.icon(     // <-- TextButton
          //     onPressed: () {
          //       storage.deleteAllToken();
          //       indexClicked = 0;
          //       Navigator.of(context).pop();
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (_) => LoginPage()));
          //     },
          //     icon: const Icon(
          //       Icons.power_settings_new_sharp,
          //       size: 30.0,
          //     ),
          //     label: const Text('Déconnexion', style: TextStyle(fontSize: 18,),),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 40, bottom: 10),
            child: Image.asset(
              'images/unicef.png',
              height: 50,
              width: 25,
            ),
          )
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
                : Defaults.drawerItemColor,
          ),
        ),
      ),
    );
  }
}
