import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var path = join(await getDatabasesPath(), 'unicefApp_db');
    await deleteDatabase(path);
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sqlEum =
        "CREATE TABLE eum (id INTEGER PRIMARY KEY AUTOINCREMENT, survey_Sid TEXT, survey_Id TEXT, user TEXT, response TEXT, questions TEXT);";
    await database.execute(sqlEum);

    String sqlRawEum = "CREATE TABLE RawEum (survey TEXT)";
    await database.execute(sqlRawEum);

    String sqlUser =
        "CREATE TABLE user (id INTEGER PRIMARY KEY, username TEXT, email TEXT, telephone TEXT, password TEXT, firstname TEXT, lastname TEXT, autorisation TEXT, organisation_id TEXT, roles TEXT, organisation TEXT, accessToken TEXT, dateCreation TEXT, updatetime TEXT, country TEXT);";
    await database.execute(sqlUser);

    String sqlSurvey =
        "CREATE TABLE survey_creation (id TEXT PRIMARY KEY, country TEXT, type TEXT,  status TEXT,  title TEXT, category TEXT, page TEXT);";
    await database.execute(sqlSurvey);

    String sqlSurveyPage =
        "CREATE TABLE survey_page (page_id INTEGER PRIMARY KEY, page_name TEXT, questions TEXT);";
    await database.execute(sqlSurveyPage);

    String sqlSurveyQuestion =
        "CREATE TABLE survey_question (question_id INTEGER PRIMARY KEY,  page_id INTEGER,  type TEXT,  `index` TEXT, text TEXT,  response TEXT, additional TEXT,  additional_response TEXT, FOREIGN KEY (page_id) REFERENCES survey_page(page_id));";
    await database.execute(sqlSurveyQuestion);
  }
}
