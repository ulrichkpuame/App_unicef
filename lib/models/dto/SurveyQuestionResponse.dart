class SurveyQuestionResponse {
  int questionid;
  String question;
  String response;

  SurveyQuestionResponse(
      {required this.questionid,
      required this.question,
      required this.response});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionid'] = questionid;
    data['question'] = question;
    data['response'] = response;
    return data;
  }

  factory SurveyQuestionResponse.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionResponse(
      questionid: json['questionid'],
      question: json['question'],
      response: json['response'],
    );
  }
}
