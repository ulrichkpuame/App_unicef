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
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }
}
