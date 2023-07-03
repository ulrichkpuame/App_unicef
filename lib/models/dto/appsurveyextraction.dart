import 'package:unicefapp/models/dto/organisation.dart';
import 'package:unicefapp/models/dto/surveyCreation.dart';

class AppSurveyExtraction {
  late SurveyCreation? survey;
  late List<Organisation> ips;
  late List<String> regions;

  AppSurveyExtraction.empty() {
    survey = null;
    ips = [];
    regions = [];
  }

  AppSurveyExtraction({
    required this.ips,
    required this.regions,
    required this.survey,
  });

  factory AppSurveyExtraction.fromJson(Map<String, dynamic> json) {
    var orgObjsJson = ((json['ips'] ?? []) as List);
    List<Organisation> _organisations =
        orgObjsJson.map((orgJson) => Organisation.fromJson(orgJson)).toList();

    var matObjsJson = ((json['regions'] ?? []) as List);
    List<String> matJson = List<String>.from(matObjsJson).toList();

    SurveyCreation _survey = SurveyCreation.fromJson(json['survey']);

    return AppSurveyExtraction(
      survey: _survey,
      ips: _organisations,
      regions: matJson,
    );
  }
}
