import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:unicefapp/models/dto/users.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    //var directory = await getApplicationDocumentsDirectory();
    //var path = join(directory.path, 'unicefApp');
    var path = join(await getDatabasesPath(), 'unicefApp');
    // await deleteDatabase(path);
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
        "CREATE TABLE user (id INTEGER PRIMARY KEY, username TEXT, email TEXT, telephone TEXT, password TEXT, firstname TEXT, lastname TEXT, autorisation TEXT, organisation_id TEXT, roles TEXT, organisation TEXT, accessToken TEXT, dateCreation TEXT, updatetime TEXT);";
    await database.execute(sqlUser);
  }
}
