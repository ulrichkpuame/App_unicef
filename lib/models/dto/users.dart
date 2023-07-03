import 'package:unicefapp/models/dto/organisation.dart';
import 'package:unicefapp/models/dto/roles.dart';

class User {
  late String id;
  String? username;
  late String email;
  String? telephone;
  late String password;
  late String firstname;
  late String lastname;
  late String autorisation;
  // ignore: non_constant_identifier_names
  // String? organisation_id;
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
    id = json['id'];
    username = json['username'];
    email = json['email'];
    telephone = json['telephone'];
    password = json['password'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    autorisation = json['autorisation'];

    var roleObjsJson = ((json['roles'] ?? []) as List);
    List<Role> _roles =
        roleObjsJson.map((roleJson) => Role.fromJson(roleJson)).toList();

    Organisation _organisation = Organisation.fromJson(json['organisation']);

    organisation = _organisation;
    organisation_id = json['organisation_id'];
    accessToken = json['accessToken'];
    dateCreation = json['dateCreation'];
    updatetime = json['updatetime'];
    roles = _roles;
  }
}
