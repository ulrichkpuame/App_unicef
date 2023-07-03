class SurveyQuestion {
  late String type;
  late String index;
  late List<String> additional;
  late String text;
  late String? response;
  late String? additional_response;

  SurveyQuestion({
    required this.type,
    required this.index,
    required this.additional,
    required this.text,
    required this.response,
    required this.additional_response,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    var matObjsJson = ((json['additional'] ?? []) as List);
    List<String> matJson = List<String>.from(matObjsJson).toList();

    return SurveyQuestion(
      type: json['type'],
      index: json['index'],
      additional: matJson,
      text: json['text'],
      response: json['response'],
      additional_response: json['additional_response'],
    );
  }
}
