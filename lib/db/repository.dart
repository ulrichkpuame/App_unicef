import 'package:sqflite/sqflite.dart';
import 'package:unicefapp/db/database.connection.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository(DatabaseConnection databaseConnection) {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  insertRawData(data) async {
    var connection = await database;
    return await connection
        ?.rawInsert('INSERT INTO RawEum(survey) VALUES(?)', [data]);
  }

  insertRaw(data) async {
    var connection = await database;
    return await connection?.rawInsert(
        'INSERT INTO survey (id, type, status, title, category, page) VALUES (?, ?, ?, ?, ?, ?)',
        [data]);
  }

  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$itemId");
  }

  deleteData(table) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table");
  }
}
