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

  Future<List<SurveyCreation>> getSurveys() async {
    final List<Map<String, dynamic>> maps =
        await _repository.readData('survey_creation');
    return List.generate(maps.length, (index) {
      return SurveyCreation.fromJson(maps[index]);
    });
  }
}
