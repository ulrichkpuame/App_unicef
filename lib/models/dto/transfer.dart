import 'package:unicefapp/models/dto/genericDocument.dart';
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
    List<Organisation> organisations =
        orgObjsJson.map((orgJson) => Organisation.fromJson(orgJson)).toList();

    var userObjsJson = json['users'] as List;
    List<User> users =
        userObjsJson.map((userJson) => User.fromJson(userJson)).toList();

    var docObjsJson = ((json['documents'] ?? []) as List);
    List<GenericDocument> documents = docObjsJson
        .map((docJson) => GenericDocument.fromJson(docJson))
        .toList();

    return Transfer(
      organisations: organisations,
      users: users,
      documents: documents,
    );
  }
}
