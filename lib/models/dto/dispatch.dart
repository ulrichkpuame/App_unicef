class Dispatch {
  String id;
  String material;
  String description;
  String beneficiaryPhone;
  String beneficaryName;
  String beneficiaryEmail;
  String quantity;
  String senderName;
  String senderEmail;
  String senderPhone;
  String dateCreateDispatch;
  String ip;
  String batchid;

  Dispatch({
    required this.id,
    required this.material,
    required this.description,
    required this.beneficiaryPhone,
    required this.beneficaryName,
    required this.beneficiaryEmail,
    required this.quantity,
    required this.senderName,
    required this.senderEmail,
    required this.senderPhone,
    required this.dateCreateDispatch,
    required this.ip,
    required this.batchid,
  });

  factory Dispatch.fromJson(Map<String, dynamic> json) {
    return Dispatch(
      id: json['id'],
      material: json['material'],
      description: json['description'],
      beneficiaryPhone: json['beneficiaryPhone'],
      beneficaryName: json['beneficaryName'],
      beneficiaryEmail: json['beneficiaryEmail'],
      quantity: json['quantity'],
      senderName: json['senderName'],
      senderEmail: json['senderEmail'],
      senderPhone: json['senderPhone'],
      dateCreateDispatch: json['dateCreateDispatch'],
      ip: json['ip'],
      batchid: json['batchid'],
    );
  }
}
