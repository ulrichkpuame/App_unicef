import 'dart:convert';

import 'package:unicefapp/models/dto/material.details.dart';

List<HistoryTransfer> historyTransferFromJson(String str) =>
    List<HistoryTransfer>.from(
        json.decode(str).map((x) => HistoryTransfer.fromJson(x)));

String historyTransferToJson(List<HistoryTransfer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson)));

class HistoryTransfer {
  late String id;
  late String country;
  late String initiatingDate;
  late String typeOfTransfer;
  late String documentNumber;
  late String ip;
  late String ipName;
  late String driverCompany;
  late String matricule;
  late String driver;
  late String driverNumber;
  late String ipReceiver;
  late String status;
  late String? dateOfReception;
  late List<MaterialDetails> materialDetails;
  late List<String> comments;
  late List<String> zrostDdelIDs;

  HistoryTransfer({
    required this.id,
    required this.country,
    required this.initiatingDate,
    required this.typeOfTransfer,
    required this.documentNumber,
    required this.ip,
    required this.ipName,
    required this.driverCompany,
    required this.matricule,
    required this.driver,
    required this.driverNumber,
    required this.ipReceiver,
    required this.status,
    required this.dateOfReception,
    required this.comments,
    required this.zrostDdelIDs,
    required this.materialDetails,
  });

  HistoryTransfer.fromJson(Map<String, dynamic> json) {
    var matsJson = json['materialDetails'];
    List<MaterialDetails> matDetails = (matsJson != null)
        ? List<MaterialDetails>.from(matsJson.runtimeType == String
            ? jsonDecode(matsJson).map(
                (materialDetails) => MaterialDetails.fromJson(materialDetails))
            : matsJson.map(
                (materialDetails) => MaterialDetails.fromJson(materialDetails)))
        : [];

    var commentsObjJson = json['comments'];
    List<String> comentJson = commentsObjJson != null
        ? List<String>.from(commentsObjJson.runtimeType == String
                ? jsonDecode(commentsObjJson)
                : commentsObjJson)
            .toList()
        : [];

    var zrostDdelIdsobjJson = json['zrostDdelIDs'];
    List<String> zrostDdelJson = zrostDdelIdsobjJson != null
        ? List<String>.from(zrostDdelIdsobjJson.runtimeType == String
                ? jsonDecode(zrostDdelIdsobjJson)
                : zrostDdelIdsobjJson)
            .toList()
        : [];

    id = json['id'] ?? '';
    country = json['country'] ?? '';
    initiatingDate = json['initiatingDate'] ?? '';
    typeOfTransfer = json['typeOfTransfer'] ?? '';
    documentNumber = json['documentNumber'] ?? '';
    ip = json['ip'] ?? '';
    ipName = json['ipName'] ?? '';
    driverCompany = json['driverCompany'] ?? '';
    matricule = json['matricule'] ?? '';
    driver = json['driver'] ?? '';
    driverNumber = json['driverNumber'] ?? '';
    ipReceiver = json['ipReceiver'] ?? '';
    status = json['status'] ?? '';
    dateOfReception = json['dateOfReception'] ?? '';
    materialDetails = matDetails;
    comments = comentJson;
    zrostDdelIDs = zrostDdelJson;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country'] = country;
    data['initiatingDate'] = initiatingDate;
    data['typeOfTransfer'] = typeOfTransfer;
    data['documentNumber'] = documentNumber;
    data['ip'] = ip;
    data['ipName'] = ipName;
    data['driverCompany'] = driverCompany;
    data['matricule'] = matricule;
    data['driver'] = driver;
    data['driverNumber'] = driverNumber;
    data['ipReceiver'] = ipReceiver;
    data['status'] = status;
    data['dateOfReception'] = dateOfReception;
    data['materialDetails'] =
        jsonEncode(materialDetails.map((details) => details.toJson()).toList());
    data['comments'] = jsonEncode(comments);
    data['zrostDdelIDs'] = jsonEncode(zrostDdelIDs);
    return data;
  }
}
