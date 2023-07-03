class Stock {
  String id;
  String material;
  String materialDescription;
  String? transferType;
  String? documentID;
  String quantity;
  String ipId;
  String ipName;

  Stock({
    required this.id,
    required this.material,
    required this.materialDescription,
    required this.transferType,
    required this.documentID,
    required this.quantity,
    required this.ipId,
    required this.ipName,
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
    );
  }
}
