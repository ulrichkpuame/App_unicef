import 'dart:convert';

import 'package:unicefapp/db/repository.dart';
import 'package:unicefapp/models/dto/genericDocument.dart';
import 'package:unicefapp/models/dto/history.transfer.dart';
import 'package:unicefapp/models/dto/issues.dart';
import 'package:unicefapp/models/dto/material.details.dart';
import 'package:unicefapp/models/dto/photo.dart';
import 'package:unicefapp/models/dto/stock.dart';
import 'package:unicefapp/models/dto/survey.dart';
import 'package:unicefapp/models/dto/surveyCreation.dart';
import 'package:unicefapp/models/dto/surveyPage.dart';
import 'package:unicefapp/models/dto/surveyQuestion.dart';

import 'package:unicefapp/models/dto/users.dart';

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

//////----------- ACKNOWLEDGE -----------------
  SaveAcknow(HistoryTransfer historyTransfer) async {
    return await _repository.insertRawDataAcknow(jsonEncode(historyTransfer));
  }

  Future<List<Map<String, dynamic>>> readAllAcknow() async {
    List<Map<String, dynamic>> list = await _repository.readData('RawAcknow');
    return list;
  }

  Future<HistoryTransfer?> readAllAcknowById(String itemId) async {
    var list = await _repository.readDataById('history_transfer', itemId);
    if (list.isNotEmpty) {
      return HistoryTransfer.fromJson(list.first);
    } else {
      return null; // Ou une autre indication si l'élément n'est pas trouvé
    }
  }

  deleteAllAcknow() async {
    return await _repository.deleteData('RawAcknow');
  }

  Future<void> saveHistoryTransfer(HistoryTransfer historyTransfer) async {
    // Utilisez le repository ou db pour insérer les données
    return await _repository.insertData(
        'history_transfer', historyTransfer.toJson());
  }

  Future<void> saveMaterialDetails(MaterialDetails materialDetails) async {
    return await _repository.insertData(
        'materials_details', materialDetails.toJson());
  }

  Future<List<HistoryTransfer>> readAllAcknowledge() async {
    List<HistoryTransfer> historyTransfer = [];
    var list = await _repository.readData('history_transfer');
    print('---------- LIST DATA  ---------');
    print(list);
    for (var history in list) {
      historyTransfer.add(HistoryTransfer.fromJson(history));
    }
    print('---------- SURVEY DATA  ---------');
    print(historyTransfer);
    return historyTransfer;
  }

  Future<List<HistoryTransfer>> getHistorytransfer() async {
    final List<Map<String, dynamic>> maps =
        await _repository.readData('history_transfer');
    return List.generate(maps.length, (index) {
      return HistoryTransfer.fromJson(maps[index]);
    });
  }

  //////----------- SURVEY CREATION -----------------

  Future<void> saveSurveyCreation(SurveyCreation surveyCreation) async {
    // Utilisez le repository ou db pour insérer les données
    return await _repository.insertData(
        'survey_creation', surveyCreation.toJson());
  }

  deleteAllSurveyCreation() async {
    return await _repository.deleteData('survey_creation');
  }

  Future<void> saveSurveyPage(SurveyPage surveyPage) async {
    return await _repository.insertData('survey_page', surveyPage.toJson());
  }

  Future<void> saveSurveyQuestion(SurveyQuestion surveyQuestion) async {
    return await _repository.insertData(
        'survey_question', surveyQuestion.toJson());
  }

  Future<List<SurveyCreation>> readAllSurveyCreation() async {
    List<SurveyCreation> surveyCreation = [];
    var list = await _repository.readData('survey_creation');
    print('---------- LIST DATA  ---------');
    print(list);
    for (var survey in list) {
      surveyCreation.add(SurveyCreation.fromJson(survey));
    }
    print('---------- SURVEY DATA  ---------');
    print(surveyCreation);
    return surveyCreation;
  }

  Future<SurveyCreation?> readSurveyCreationById(String itemId) async {
    var list = await _repository.readDataById('survey_creation', itemId);
    if (list.isNotEmpty) {
      return SurveyCreation.fromJson(list.first);
    } else {
      return null; // Ou une autre indication si l'élément n'est pas trouvé
    }
  }

  Future<SurveyCreation> readSurveyCreationById1(int surveyid) async {
    return await _repository.readDataById('survey_creation', surveyid);
  }

  Future<List<SurveyCreation>> getSurveys() async {
    final List<Map<String, dynamic>> maps =
        await _repository.readData('survey_creation');
    return List.generate(maps.length, (index) {
      return SurveyCreation.fromJson(maps[index]);
    });
  }

  SaveUser(User user) async {
    return await _repository.insertData('user', user.toJson());
  }

  //////----------- PHOTO -----------------
  SavePhoto(Photo photo) async {
    return await _repository.insertData('photo', photo.toJson());
  }

  Future<List<Photo>> getPhotos() async {
    final List<Map<String, dynamic>> maps = await _repository.readData('photo');
    List<Photo> photos = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        photos.add(Photo.fromJson(maps[i]));
      }
    }
    return photos;
  }
}
