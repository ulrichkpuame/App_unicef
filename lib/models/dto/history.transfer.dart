import 'package:unicefapp/models/dto/material.details.dart';

class HistoryTransfer {
  String id;
  String initiatingDate;
  String typeOfTransfer;
  late List<MaterialDetails> materialDetails;
  String documentNumber;
  String ip;
  String ipName;
  String driverCompany;
  String driver;
  String ipReceiver;
  String status;
  String? dateOfReception;
  List<String> comments;
  List<String> zrostDdelIDs;
  String matricule;
  String driverNumber;

  HistoryTransfer({
    required this.id,
    required this.initiatingDate,
    required this.typeOfTransfer,
    required this.materialDetails,
    required this.documentNumber,
    required this.ip,
    required this.ipName,
    required this.driverCompany,
    required this.driver,
    required this.ipReceiver,
    required this.status,
    required this.dateOfReception,
    required this.comments,
    required this.zrostDdelIDs,
    required this.matricule,
    required this.driverNumber,
  });

  factory HistoryTransfer.fromJson(Map<String, dynamic> json) {
    var matObjsJson = ((json['materialDetails'] ?? []) as List);
    List<MaterialDetails> matJson =
        matObjsJson.map((e) => MaterialDetails.fromJson(e)).toList();

    return HistoryTransfer(
      id: json['id'],
      initiatingDate: json['initiatingDate'],
      typeOfTransfer: json['typeOfTransfer'],
      materialDetails: matJson,
      documentNumber: json['documentNumber'],
      ip: json['ip'],
      ipName: json['ipName'],
      driverCompany: json['driverCompany'],
      driver: json['driver'],
      ipReceiver: json['ipReceiver'],
      status: json['status'],
      dateOfReception: json['dateOfReception'],
      comments: [],
      zrostDdelIDs: [],
      matricule: json['matricule'],
      driverNumber: json['driverNumber'],
    );
  }
}
