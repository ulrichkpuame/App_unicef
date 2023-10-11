// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unicefapp/di/service_locator.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';

import '../../_api/authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authService = locator<AuthService>();
  // final dbHandler = locator<LocalService>();
  // final apiService = locator<ApiService>();
  final _formKey = GlobalKey<FormState>();
  bool notvisible = true;
  Agent? agentConnected;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Theme(
          data: ThemeData(primarySwatch: Defaults.primaryBleuColor),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  //padding: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                      child: Image.asset(
                    'images/unicef1.png',
                    width: 200,
                    height: 200,
                  )),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "TRACKIT EUM",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Defaults.bluePrincipal),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: TextFormField(
                    autocorrect: false,
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Defaults.blueSecond,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Colors.black12), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.black12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password';
                      }
                      return null;
                    },
                    obscureText: notvisible,
                    autocorrect: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Defaults.blueSecond,
                        suffixIcon: IconButton(
                            icon: Icon(notvisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                notvisible = !notvisible;
                              });
                            }),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.black12), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Password'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: SizedBox(
                    height: 50,
                    width: 500,
                    child: ElevatedButton(
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                      onPressed: () async {
                        _submitLogin();
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    "FORGET PASSWORD ?",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Defaults.bluePrincipal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicatorDialog().show(context);
      // log(usernameController.text);
      // try {
      var statusCode = await authService.authenticateUser(
          usernameController.text.trim(), passwordController.text.trim());
      if (statusCode == 200) {
        LoadingIndicatorDialog().dismiss();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else {
        LoadingIndicatorDialog().dismiss();
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'ERROR',
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  height: 120,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'animations/auth.json',
                        repeat: true,
                        reverse: true,
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      const Text(
                        'Incorrect username and or password',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Retry'))
                ],
              );
            });
      }
    }
  }
}
