import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/ui/pages/user.info.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool val1 = true;
  onChangeMethod1(bool value) {
    setState(() {
      val1 = value;
    });
  }

  bool val2 = false;
  onChangeMethod2(bool value) {
    setState(() {
      val2 = value;
    });
  }

  bool val3 = false;
  onChangeMethod3(bool value) {
    setState(() {
      val3 = value;
    });
  }

  bool val4 = true;
  onChangeMethod4(bool value) {
    setState(() {
      val4 = value;
    });
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
                  )),
            ],
          ),
          title: const Column(
            children: [
              Text(
                'Settings',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'User settings',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
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
              Container(
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
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UserInfoPage()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Personal Information',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Defaults.black),
                                    ),
                                    Icon(Icons.navigate_next,
                                        color: Defaults.black),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Country',
                                    style: TextStyle(
                                        color: Defaults.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Language',
                                    style: TextStyle(
                                        color: Defaults.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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
              Container(
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
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              customSwitch(
                                  'Check for updates', val2, onChangeMethod2),
                              customSwitch(
                                  'Remember Me', val3, onChangeMethod3),
                              customSwitch(
                                  'Notifications', val4, onChangeMethod4),
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
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customSwitch(String text, bool val, Function onChangeMethod) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
              color: Defaults.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        CupertinoSwitch(
          value: val,
          onChanged: (value) {
            onChangeMethod(value);
          },
          trackColor: Colors.grey,
          activeColor: Defaults.bluePrincipal,
        ),
      ],
    ),
  );
}
