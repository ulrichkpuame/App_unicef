class Issue {
  String id;
  String typeOfTransfer;
  String material;
  int sentQuantity;
  int reportedQuantity;
  String documentNumber;
  String ip;
  String ipName;
  String driver;
  String ipReceiver;
  String dateOfReception;
  String status;
  String? comments;
  String? closeById;
  String? closeByName;

  Issue({
    required this.id,
    required this.typeOfTransfer,
    required this.material,
    required this.sentQuantity,
    required this.reportedQuantity,
    required this.documentNumber,
    required this.ip,
    required this.ipName,
    required this.driver,
    required this.ipReceiver,
    required this.dateOfReception,
    required this.status,
    required this.comments,
    required this.closeById,
    required this.closeByName,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      typeOfTransfer: json['typeOfTransfer'],
      material: json['material'],
      sentQuantity: json['sentQuantity'],
      reportedQuantity: json['reportedQuantity'],
      documentNumber: json['documentNumber'],
      ip: json['ip'],
      ipName: json['ipName'],
      driver: json['driver'],
      ipReceiver: json['ipReceiver'],
      dateOfReception: json['dateOfReception'],
      status: json['status'],
      comments: json['comments'],
      closeById: json['closeById'],
      closeByName: json['closeByName'],
    );
  }
}
