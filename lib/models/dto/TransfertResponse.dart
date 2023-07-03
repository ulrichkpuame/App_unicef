class TransfertResponse {
  String source;
  String waybill;
  String supplier;
  String driver;
  String ipspoc;
  String matriculeVehicule;
  String senderName;
  String senderPhone;
  String senderEmail;
  String consignee;
  String consigneeName;
  List<String> cc;

  TransfertResponse({
    required this.source,
    required this.waybill,
    required this.supplier,
    required this.driver,
    required this.ipspoc,
    required this.matriculeVehicule,
    required this.senderName,
    required this.senderPhone,
    required this.senderEmail,
    required this.consignee,
    required this.consigneeName,
    required this.cc,
  });
}
