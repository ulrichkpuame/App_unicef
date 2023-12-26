import 'dart:convert';

import 'package:unicefapp/models/dto/surveyQuestion.dart';

class SurveyPage {
  late int page_id;
  late String page_name;
  late List<SurveyQuestion> questions;

  SurveyPage({
    required this.page_id,
    required this.page_name,
    required this.questions,
  });

  @override
  String toString() {
    return 'SurveyPage{page_id: $page_id, page_name: $page_name, questions: $questions}';
  }

  SurveyPage.fromJson(Map<String, dynamic> json) {
    var surpageObjsJson = ((json['questions'] ?? []) as List);
    List<SurveyQuestion> matJson =
        surpageObjsJson.map((e) => SurveyQuestion.fromJson(e)).toList();

    // return SurveyPage(
    page_id = json['page_id'];
    page_name = json['page_name'];
    questions = matJson;
    // );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_id'] = page_id;
    data['page_name'] = page_name;
    data['questions'] =
        jsonEncode(questions.map((question) => question.toJson()).toList());
    return data;
  }
}
