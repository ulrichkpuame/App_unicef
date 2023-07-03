import 'package:unicefapp/models/dto/surveyPage.dart';

class SurveyCreation {
  late String id;
  late String type; //EUM or PMV
  late String status;
  late String title;
  late String category;
  late List<SurveyPage> page;

  SurveyCreation(
      {required this.id,
      required this.type,
      required this.status,
      required this.title,
      required this.category,
      required this.page});

  factory SurveyCreation.fromJson(Map<String, dynamic> json) {
    var matObjsJson = ((json['page'] ?? []) as List);
    List<SurveyPage> matJson =
        matObjsJson.map((e) => SurveyPage.fromJson(e)).toList();

    return SurveyCreation(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      page: matJson,
      title: json['title'],
      category: json['category'],
    );
  }
}
