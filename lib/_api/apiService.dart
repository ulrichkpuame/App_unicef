import 'package:unicefapp/_api/dioClient.dart';
import 'package:unicefapp/_api/endpoints.dart';
import 'package:unicefapp/models/dto/genericDocument.dart';
import 'package:unicefapp/models/dto/surveyCreation.dart';
import 'package:unicefapp/models/dto/users.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<List<User>> getUsers() async {
    final response = await _dioClient.get(Endpoints.user);
    List<User> users =
        (response.data as List).map((e) => User.fromJson(e)).toList();
    return users;
  }

  // Future<List<SurveyCreation>> getAllSurveyCreation() async {
  //   String surveyEndpoints = 'http://192.168.1.10:8094/u/activeSurveys';
  //   final response = await _dioClient.get(surveyEndpoints);
  //   List<dynamic> data = response.data;
  //   List<SurveyCreation> surveyCreation =
  //       data.map((e) => SurveyCreation.fromJson(e)).toList();
  //   return surveyCreation;
  // }
}
