import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:unicefapp/models/dto/agent.dart';
import 'package:unicefapp/models/dto/tokenModel.dart';

class TokenStorageService {
  // Create storage
  final FlutterSecureStorage _storage;
  static const String TOKEN_KEY = "TOKEN";
  static const String USERNAME_KEY = "USERNAME";
  static const String EMAIL_KEY = "EMAIL";
  static const String TELEPHONE_KEY = "TELEPHONE";
  static const String FIRSTNAME_KEY = "FIRSTNAME";
  static const String LASTNAME_KEY = "LASTNAME";
  static const String ROLES_KEY = "ROLES";

  TokenStorageService(this._storage);

  void saveToken(String token) async {
    await _storage.write(key: TOKEN_KEY, value: token);
  }

  void saveAgentConnected(Agent agent) async {
    await _storage.write(key: USERNAME_KEY, value: agent.username);
    await _storage.write(key: EMAIL_KEY, value: agent.email);
    await _storage.write(key: TELEPHONE_KEY, value: agent.telephone);
    await _storage.write(key: FIRSTNAME_KEY, value: agent.firstname);
    await _storage.write(key: LASTNAME_KEY, value: agent.lastname);
    await _storage.write(key: ROLES_KEY, value: agent.roles);
  }

  Future<Agent?> retrieveAgentConnected() async {
    String? username = await _storage.read(key: USERNAME_KEY);
    String? email = await _storage.read(key: EMAIL_KEY);
    String? telephone = await _storage.read(key: TELEPHONE_KEY);
    String? firstname = await _storage.read(key: FIRSTNAME_KEY);
    String? lastname = await _storage.read(key: LASTNAME_KEY);
    String? roles = await _storage.read(key: ROLES_KEY);
    Agent agentConnected = Agent(
        username: username,
        email: email,
        telephone: telephone,
        firstname: firstname,
        lastname: lastname,
        roles: roles);
    return agentConnected;
  }

  Future<String?> retrieveAccessToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return TokenModel.fromJson(jsonDecode(tokenJson)).accessToken;
  }

  Future<String?> retrieveRefreshToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return TokenModel.fromJson(jsonDecode(tokenJson)).refreshToken;
  }

  Future<bool> isTokenExist() async {
    return await _storage.containsKey(key: TOKEN_KEY);
  }

  Future<void> deleteAllToken() async {
    _storage.deleteAll();
  }

  deleteToken(String tokenKey) {
    _storage.delete(key: tokenKey);
  }
}
