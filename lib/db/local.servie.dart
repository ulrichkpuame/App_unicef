import 'dart:convert';

import 'package:unicefapp/db/repository.dart';
import 'package:unicefapp/models/dto/genericDocument.dart';
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

  // SAVE USER
  SaveUser(User user) async {
    return await _repository.insertData('user', user.toJson());
  }

  Future<void> saveSurveyCreation(SurveyCreation surveyCreation) async {
    // Utilisez le repository ou db pour insérer les données
    return await _repository.insertData(
        'survey_creation', surveyCreation.toJson());
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
    List<Map<String, dynamic>> list =
        await _repository.readData('survey_creation');
    for (var survey in list) {
      surveyCreation.add(SurveyCreation.fromJson(survey));
    }
    return surveyCreation;
  }
}
