import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  }
}
