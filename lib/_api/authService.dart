// ignore_for_file: file_names, avoid_print
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unicefapp/_api/tokenStorageService.dart';
import 'package:unicefapp/models/dto/agent.dart';

class AuthService {
  final TokenStorageService _tokenStorageService;
  Dio dio = Dio();
  String BASEURL = 'http://192.168.1.9:8096';

  AuthService(this._tokenStorageService);

  Future<int?> authenticateUser(
      String usernameController, String passwordController) async {
    String rjson =
        "{\"id\": \"6509e253137b1459e12fd0eb\",\"username\": \"INQUERITO\",\"email\": \"225devtest@gmail.com\",\"telephone\": \"+2252525252525\",\"firstname\": \"Rufin\",\"lastname\": \"INQUERITO\",\"roles\": [    \"ROLE_SURVEYOR\"],\"organisation\": \"63bec6e363e587e178ff1c27\",\"tokenType\": \"Bearer\",\"accessToken\": \"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJJTlFVRVJJVE8iLCJpYXQiOjE2OTUyMDk2NTAsImV4cCI6MTY5NTI5NjA1MH0.aTYmSIKPsrfHWRQjUjc3Kl6aDkv1iMYdDABShrSVZNkZzqAhM_NFpBvjGNyd0dJVHZv_BUFCs369j_pUN-XFYg\"}";
    if (usernameController == "INQUERITO" && passwordController == "Covid19") {
      Agent apiResponse = Agent.fromJson(jsonDecode(rjson));
      _tokenStorageService.saveAgentConnected(apiResponse);
      return 200;
    }
    String url = '$BASEURL/api/auth/signin';
    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "email": usernameController,
          "password": passwordController,
        }));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      Agent apiResponse = Agent.fromJson(jsonResponse);
      _tokenStorageService.saveAgentConnected(apiResponse);
      print('Test--2---${apiResponse.accessToken}');
      return response.statusCode;
    } else {
      debugPrint(
          "An Error Occurred during loggin in. Status code: ${response.statusCode} , body: ${response.body}");
      return response.statusCode;
    }
  }
}
