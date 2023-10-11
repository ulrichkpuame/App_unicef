import 'dart:convert';

import 'package:unicefapp/models/dto/material.details.dart';

List<HistoryTransfer> historyTransferFromJson(String str) =>
    List<HistoryTransfer>.from(
        json.decode(str).map((x) => HistoryTransfer.fromJson(x)));

String historyTransferToJson(List<HistoryTransfer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson)));

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
      id: json['id'] ?? '',
      initiatingDate: json['initiatingDate'] ?? '',
      typeOfTransfer: json['typeOfTransfer'] ?? '',
      materialDetails: matJson,
      documentNumber: json['documentNumber'] ?? '',
      ip: json['ip'] ?? '',
      ipName: json['ipName'] ?? '',
      driverCompany: json['driverCompany'] ?? '',
      driver: json['driver'] ?? '',
      ipReceiver: json['ipReceiver'] ?? '',
      status: json['status'] ?? '',
      dateOfReception: json['dateOfReception'] ?? '',
      comments: [],
      zrostDdelIDs: [],
      matricule: json['matricule'] ?? '',
      driverNumber: json['driverNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['initiatingDate'] = initiatingDate;
    data['typeOfTransfer'] = typeOfTransfer;
    data['materialDetails'] = materialDetails;
    data['documentNumber'] = documentNumber;
    data['ip'] = ip;
    data['ipName'] = ipName;
    data['driverCompany'] = driverCompany;
    data['driver'] = driver;
    data['ipReceiver'] = ipReceiver;
    data['status'] = status;
    data['dateOfReception'] = dateOfReception;
    data['comments'] = comments;
    data['zrostDdelIDs'] = zrostDdelIDs;
    data['matricule'] = matricule;
    data['driverNumber'] = driverNumber;
    return data;
  }
}
