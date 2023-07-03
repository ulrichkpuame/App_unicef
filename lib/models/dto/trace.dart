class Trace {
  String? id;
  String? recordDate;
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
      id: json['id'],
      recordDate: json['recordDate'],
      material: json['material'],
      materialDescription: json['materialDescription'],
      ip: json['ip'],
      ipName: json['ipName'],
      driver: json['driver'],
      ipReceiver: json['ipReceiver'],
      dateOfReception: json['dateOfReception'],
      batchID: json['batchID'],
      comment: json['comment'],
      image: json['image'],
    );
  }
}
