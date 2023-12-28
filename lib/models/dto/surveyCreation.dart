import 'dart:convert';

import 'package:unicefapp/models/dto/surveyPage.dart';

class SurveyCreation {
  late String id;
  late String country;
  late String type; //EUM or PMV
  late String status;
  late String title;
  late String category;
  late List<SurveyPage> page;

  SurveyCreation(
      {required this.id,
      required this.country,
      required this.type,
      required this.status,
      required this.title,
      required this.category,
      required this.page});

  @override
  String toString() {
    return 'SurveyCreation{id: $id, country: $country, type: $type, status: $status, title: $title, category: $category, page: $page}';
  }

  SurveyCreation.fromJson(Map<String, dynamic> json) {
    var pagesJson = json['page'];
    List<SurveyPage> pages = (pagesJson != null)
        ? List<SurveyPage>.from(pagesJson.runtimeType == String
            ? jsonDecode(pagesJson).map((page) => SurveyPage.fromJson(page))
            : pagesJson.map((page) => SurveyPage.fromJson(page)))
        : [];

    id = json['id'];
    country = json['country'];
    type = json['type'];
    status = json['status'];
    title = json['title'];
    category = json['category'];
    page = pages;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country'] = country;
    data['type'] = type;
    data['status'] = status;
    data['title'] = title;
    data['category'] = category;
    data['page'] = jsonEncode(page.map((page) => page.toJson()).toList());
    return data;
  }
}
