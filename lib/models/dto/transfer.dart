import 'package:unicefapp/models/dto/generateDocument.dart';
import 'package:unicefapp/models/dto/organisation.dart';
import 'package:unicefapp/models/dto/users.dart';

class Transfer {
  late List<Organisation> organisations;
  late List<User> users;
  late List<GenericDocument> documents;

  Transfer({
    required this.organisations,
    required this.users,
    required this.documents,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    var orgObjsJson = ((json['organisations'] ?? []) as List);
    List<Organisation> _organisations =
        orgObjsJson.map((orgJson) => Organisation.fromJson(orgJson)).toList();

    var userObjsJson = json['users'] as List;
    List<User> _users =
        userObjsJson.map((userJson) => User.fromJson(userJson)).toList();

    var docObjsJson = ((json['documents'] ?? []) as List);
    List<GenericDocument> _documents = docObjsJson
        .map((docJson) => GenericDocument.fromJson(docJson))
        .toList();

    return Transfer(
      organisations: _organisations,
      users: _users,
      documents: _documents,
    );
  }
}
