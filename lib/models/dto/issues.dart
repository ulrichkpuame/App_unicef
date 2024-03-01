class Issue {
  String id;
  String country;
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
    required this.country,
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
      country: json['country'],
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['country'] = country;
    data['typeOfTransfer'] = typeOfTransfer;
    data['material'] = material;
    data['sentQuantity'] = sentQuantity;
    data['reportedQuantity'] = reportedQuantity;
    data['documentNumber'] = documentNumber;
    data['ip'] = ip;
    data['ipName'] = ipName;
    data['driver'] = driver;
    data['ipReceiver'] = ipReceiver;
    data['dateOfReception'] = dateOfReception;
    data['status'] = status;
    data['comments'] = comments;
    data['closeById'] = closeById;
    data['closeByName'] = closeByName;
    return data;
  }
}
