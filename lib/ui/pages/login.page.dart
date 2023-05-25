import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:unicefapp/_api/apiService.dart';
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/ui/pages/home.page.dart';
import 'package:unicefapp/widgets/default.colors.dart';
import 'package:unicefapp/widgets/error.dialog.dart';
import 'package:unicefapp/widgets/loading.indicator.dart';

import '../../_api/authService.dart';
import '../../di/service_locator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //final authService = locator<AuthService>();
  final apiService = locator<ApiService>();
  final storage = locator<TokenStorageService>();
  final _formKey = GlobalKey<FormState>();
  bool notvisible = true;
  Agent? agentConnected;
  bool isLoading = false;

  @override
  void dispose() {
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
                    'images/unicef.png',
                    width: 200,
                    height: 200,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un nom utilisateur';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nom utilisateur',
                        hintText: 'Enter votre nom utilisateur'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 35, bottom: 0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un mot de passe';
                      }
                      return null;
                    },
                    obscureText: notvisible,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(notvisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                notvisible = !notvisible;
                              });
                            }),
                        border: const UnderlineInputBorder(),
                        labelText: 'Mot de passe',
                        hintText: 'Entrer votre mot de passe'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 35, bottom: 0),
                    child: Container(
                      height: 50,
                      width: 500,
                      child: ElevatedButton(
                        child: const Text('Connexion',
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                        onPressed: () async {
                          _submitLogin();
                        },
                      ),
                    ))
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
      log(usernameController.text);
      try {
        var statusCode = await authService.authenticateUser(
            usernameController.text.trim(), passwordController.text);
        if (statusCode == 200) {
          LoadingIndicatorDialog().dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        }
      } on DioError catch (e) {
        LoadingIndicatorDialog().dismiss();
        ErrorDialog().show(e);
      }
    }
  }
}
