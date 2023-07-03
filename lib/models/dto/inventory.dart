class Inventory {
  final String material_description;
  final String quantity;

  Inventory({
    required this.material_description,
    required this.quantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      material_description: json['material_description'],
      quantity: json['quantity'],
    );
  }
}
