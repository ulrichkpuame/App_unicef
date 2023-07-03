class DTOSurveyExtration {
  String? survey_completed_id;
  late String survey_id;
  late String title;
  late String category;
  late String status;

  DTOSurveyExtration({
    this.survey_completed_id,
    required this.survey_id,
    required this.title,
    required this.category,
    required this.status,
  });

  factory DTOSurveyExtration.fromJson(Map<String, dynamic> json) {
    return DTOSurveyExtration(
      survey_completed_id: json['survey_completed_id'],
      survey_id: json['survey_id'],
      title: json['title'],
      category: json['category'],
      status: json['status'],
    );
  }
}
