import 'dart:convert';

List<Organisation> organisationFromJson(String str) => List<Organisation>.from(
    json.decode(str).map((x) => Organisation.fromJson(x)));

String organisationToJson(List<Organisation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson)));

class Organisation {
  late String id;
  late String name;
  late String type;

  Organisation({
    required this.id,
    required this.name,
    required this.type,
  });

  Organisation.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}
