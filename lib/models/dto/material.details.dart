class MaterialDetails {
  late String materialName;
  late String materialDescription;
  late String materialQuantity;
  String? materialQuantityReceived;

  MaterialDetails({
    required this.materialName,
    required this.materialDescription,
    required this.materialQuantity,
    required this.materialQuantityReceived,
  });

  MaterialDetails.fromJson(Map<String, dynamic> json) {
    materialName = json['materialName'];
    materialDescription = json['materialDescription'];
    materialQuantity = json['materialQuantity'];
    materialQuantityReceived = json['materialQuantityReceived'];
  }
}
