import 'dart:convert';

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

  @override
  String toString() {
    return 'SurveyQuestion{type: $type, index: $index, additional: $additional, text: $text, response: $response, additional_response: $additional_response}';
  }

  SurveyQuestion.fromJson(Map<String, dynamic> json) {
    // vérifie si additional est vide avant de le convertir
    var additionalObjsJson = json['additional'];
    List<String> additionalJson = additionalObjsJson != null
        ? List<String>.from(additionalObjsJson).toList()
        : [];

    // return SurveyQuestion(
    type = json['type'];
    index = json['index'];
    additional = additionalJson;
    text = json['text'];
    response = json['response'];
    additional_response = json['additional_response'];
    // );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['index'] = index;
    data['additional'] = jsonEncode(additional);
    data['text'] = text;
    data['response'] = response;
    data['additional_response'] = additional_response;
    return data;
  }
}
