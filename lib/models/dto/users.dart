import 'package:unicefapp/models/dto/organisation.dart';
import 'package:unicefapp/models/dto/roles.dart';
import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson)));

class User {
  late String id;
  String? username;
  late String email;
  String? telephone;
  late String password;
  late String firstname;
  late String lastname;
  late String autorisation;
  late String organisation_id;
  late List<Role> roles;
  late Organisation organisation;
  String? accessToken;
  String? dateCreation;
  String? updatetime;

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, telephone: $telephone, password: $password, firstname: $firstname, lastname: $lastname, autorisation: $autorisation, organisation_id: $organisation_id, roles: $roles, organisation: $organisation, accessToken: $accessToken, dateCreation: $dateCreation, updatetime: $updatetime}';
  }

  User(
      {required this.id,
      this.username,
      required this.email,
      this.telephone,
      required this.password,
      required this.firstname,
      required this.lastname,
      required this.autorisation,
      required this.organisation_id,
      required this.roles,
      required this.organisation,
      this.accessToken,
      this.dateCreation,
      this.updatetime});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    telephone = json['telephone'] ?? '';
    password = json['password'] ?? '';
    firstname = json['firstname'] ?? '';
    lastname = json['lastname'] ?? '';
    autorisation = json['autorisation'] ?? '';

    var roleObjsJson = ((json['roles'] ?? []) as List);
    List<Role> _roles =
        roleObjsJson.map((roleJson) => Role.fromJson(roleJson)).toList();

    // Mettez à jour la désérialisation du champ organisation
    var organisationJson = json['organisation'];
    if (organisationJson is Map<String, dynamic>) {
      Organisation _organisation = Organisation.fromJson(organisationJson);
      organisation = _organisation;
    } else {
      // Gérez le cas où le champ organisation n'est pas un objet JSON valide
      // Vous pouvez initialiser organisation avec des valeurs par défaut ou null, par exemple.
      organisation = Organisation(id: '', name: '', type: '');
    }

    organisation_id = json['organisation_id'] ?? '';
    accessToken = json['accessToken'] ?? '';
    dateCreation = json['dateCreation'] ?? '';
    updatetime = json['updatetime'] ?? '';
    roles = _roles;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['telephone'] = telephone;
    data['password'] = password;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['autorisation'] = autorisation;
    data['organisation_id'] = organisation_id;
    data['roles'] = roles;
    data['organisation'] = organisation;
    data['accessToken'] = accessToken;
    data['dateCreation'] = dateCreation;
    data['updatetime'] = updatetime;
    return data;
  }
}
