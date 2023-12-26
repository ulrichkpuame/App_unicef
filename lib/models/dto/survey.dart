import 'package:unicefapp/models/dto/SurveyQuestionResponse.dart';

class Survey {
  String userid;
  String country;
  String surveyid;
  List<SurveyQuestionResponse> questionresponse;

  Survey({
    required this.userid,
    required this.country,
    required this.surveyid,
    required this.questionresponse,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['country'] = country;
    data['surveyid'] = surveyid;
    data['questionresponse'] = questionresponse;
    return data;
  }

  factory Survey.fromJson(Map<String, dynamic> json) {
    var surpageObjsJson = ((json['questionresponse'] ?? []) as List);
    List<SurveyQuestionResponse> matJson =
        surpageObjsJson.map((e) => SurveyQuestionResponse.fromJson(e)).toList();

    return Survey(
      userid: json['userid'],
      country: json['country'],
      surveyid: json['surveyid'],
      questionresponse: matJson,
    );
  }
}
