import 'memo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String TableName = 'memos';

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), '$TableName.db'),

      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $TableName(id TEXT PRIMARY KEY, title TEXT, text TEXT, createdAt TEXT, editedAt TEXT)'
        );
      },

      version: 1,
    );
    return _db;
  }

  Future<void> insertMemo(Memo memo) async {
    final db = await database;

    await db.insert(
      TableName,
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memo>> memos() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TableName);

    return List.generate(maps.length, (i) {
      return Memo(
          id: maps[i]['id'],
          title: maps[i]['title'],
          text: maps[i]['text'],
          createdAt: maps[i]['createdAt'],
          editedAt: maps[i]['editedAt']
      );
    });
  }

  Future<List<Memo>> findMemo(String id) async{
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TableName, where: 'id = ?', whereArgs: [id]);

    return List.generate(maps.length, (i) {
      return Memo(
          id: maps[i]['id'],
          title: maps[i]['title'],
          text: maps[i]['text'],
          createdAt: maps[i]['createdAt'],
          editedAt: maps[i]['editedAt']
      );
    });
  }

  Future<void> updateMemo(Memo memo) async {
    final db = await database;

    await db.update(
      TableName,
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  Future<void> deleteMemo(String id) async {
    final db = await database;

    await db.delete(
      TableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}