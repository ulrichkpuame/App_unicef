class Stock {
  String id;
  String material;
  String materialDescription;
  String? transferType;
  String? documentID;
  String quantity;
  String ipId;
  String ipName;
  String country;

  Stock({
    required this.id,
    required this.material,
    required this.materialDescription,
    required this.transferType,
    required this.documentID,
    required this.quantity,
    required this.ipId,
    required this.ipName,
    required this.country,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      material: json['material'],
      materialDescription: json['materialDescription'],
      transferType: json['transferType'],
      documentID: json['documentID'],
      quantity: json['quantity'],
      ipId: json['ipId'],
      ipName: json['ipName'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['material'] = material;
    data['materialDescription'] = materialDescription;
    data['transferType'] = transferType;
    data['documentID'] = documentID;
    data['quantity'] = quantity;
    data['ipId'] = ipId;
    data['ipName'] = ipName;
    data['country'] = country;
    return data;
  }
}
