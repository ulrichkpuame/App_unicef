import 'dart:convert';

List<Trace> traceFromJson(String str) =>
    List<Trace>.from(json.decode(str).map((x) => Trace.fromJson(x)));

String traceToJson(List<Trace> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson)));

class Trace {
  String? id;
  String? recordDate;
  String? country;
  String? material;
  String? materialDescription;
  String? transferType;
  String? ip;
  String? ipName;
  String? driver;
  String? ipReceiver;
  String? dateOfReception;
  String? batchID;
  String? comment;
  String? image;

  Trace({
    required this.id,
    required this.recordDate,
    required this.country,
    required this.material,
    required this.materialDescription,
    required this.ip,
    required this.ipName,
    required this.driver,
    required this.ipReceiver,
    required this.dateOfReception,
    required this.batchID,
    required this.comment,
    required this.image,
  });

  factory Trace.fromJson(Map<String, dynamic> json) {
    return Trace(
      id: json['id'] ?? '',
      recordDate: json['recordDate'] ?? '',
      country: json['country'] ?? '',
      material: json['material'] ?? '',
      materialDescription: json['materialDescription'] ?? '',
      ip: json['ip'] ?? '',
      ipName: json['ipName'] ?? '',
      driver: json['driver'] ?? '',
      ipReceiver: json['ipReceiver'] ?? '',
      dateOfReception: json['dateOfReception'] ?? '',
      batchID: json['batchID'] ?? '',
      comment: json['comment'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['recordDate'] = recordDate;
    data['country'] = country;
    data['material'] = material;
    data['materialDescription'] = materialDescription;
    data['ip'] = ip;
    data['ipName'] = ipName;
    data['driver'] = driver;
    data['ipReceiver'] = ipReceiver;
    data['dateOfReception'] = dateOfReception;
    data['batchID'] = batchID;
    data['comment'] = comment;
    data['image'] = image;
    return data;
  }
}
