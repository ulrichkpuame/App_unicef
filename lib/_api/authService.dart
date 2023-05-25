// ignore_for_file: file_names, avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // TextEditingController usernameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  Future<int?> authenticateUser(
      String usernameController, String passwordController) async {
    String url = 'https://www.digitale-it.com/unicef/api/auth/signin';
    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "username": usernameController,
          "password": passwordController,
        }));
    if (response.statusCode == 200) {
      print(json.encode(response.body));
      // _tokenStorageService.saveToken(json.encode(response.body));
      print('--------------access-------------------');
      //print(await _tokenStorageService.retrieveAccessToken());
      print('-----------refresh----------------------');
      //print(await _tokenStorageService.retrieveRefreshToken());
      return response.statusCode;
    } else {
      debugPrint(
          "An Error Occurred during loggin in. Status code: ${response.statusCode} , body: ${response.body}");
      return response.statusCode;
    }
  }
}
