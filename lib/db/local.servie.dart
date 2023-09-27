import 'dart:convert';

import 'package:unicefapp/db/repository.dart';
import 'package:unicefapp/models/dto/eum.local.dart';
import 'package:unicefapp/models/dto/survey.dart';
import 'package:unicefapp/models/dto/transfer.dart';

import 'package:http/http.dart' as http;

class LocalService {
  final Repository _repository;

  LocalService(this._repository);

  //SAVE EUMLOCAL IN DATABASE
  SaveEum(Survey survey) async {
    return await _repository.insertRawData(jsonEncode(survey));
  }

  //READ ALLSURVEY
  Future<List<Map<String, dynamic>>> readAllSurvey() async {
    List<Map<String, dynamic>> list = await _repository.readData('RawEum');
    return list;
  }

  deleteAllEum() async {
    return await _repository.deleteData('RawEum');
  }
}
