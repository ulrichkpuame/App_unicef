class MaterialDetails {
  late String materialName;
  late String materialDescription;
  late String materialQuantity;
  late String materialQuantityReceived; // Change here

  MaterialDetails({
    required this.materialName,
    required this.materialDescription,
    required this.materialQuantity,
    required this.materialQuantityReceived,
  });

  factory MaterialDetails.fromJson(Map<String, dynamic> json) {
    return MaterialDetails(
      materialName: json['materialName'],
      materialDescription: json['materialDescription'],
      materialQuantity: json['materialQuantity'],
      materialQuantityReceived: json['materialQuantityReceived'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['materialName'] = materialName;
    data['materialDescription'] = materialDescription;
    data['materialQuantity'] = materialQuantity;
    data['materialQuantityReceived'] = materialQuantityReceived;
    return data;
  }
}
