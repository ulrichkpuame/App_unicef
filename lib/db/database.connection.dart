import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    //var directory = await getApplicationDocumentsDirectory();
    //var path = join(directory.path, 'db_crud');
    var path = join(await getDatabasesPath(), 'db_crud');
    await deleteDatabase(path);
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sqlTransfer =
        "CREATE TABLE facture (id INTEGER PRIMARY KEY, username TEXT, email TEXT, telephone TEXT, firstname TEXT, lastname TEXT, autorisation TEXT, organisation_id TEXT, organisation TEXT, roles TEXT, dateCreation TEXT, updatetime TEXT);";
    await database.execute(sqlTransfer);
  }
}
