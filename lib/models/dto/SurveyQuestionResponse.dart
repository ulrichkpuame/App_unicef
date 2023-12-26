class SurveyQuestionResponse {
  int questionid;
  String country;
  String question;
  String response;

  SurveyQuestionResponse(
      {required this.questionid,
      required this.country,
      required this.question,
      required this.response});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionid'] = questionid;
    data['country'] = country;
    data['question'] = question;
    data['response'] = response;
    return data;
  }

  factory SurveyQuestionResponse.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionResponse(
      questionid: json['questionid'],
      country: json['country'],
      question: json['question'],
      response: json['response'],
    );
  }
}
