import 'package:e_store/data/models/cart_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDb {
  _initDb() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'favorite.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE favorite(id TEXT PRIMARY KEY)");
      },
      version: 1,
    );
    return db;
  }

  Future<bool> insertProduct(String productId) async {
    final Database db = await _initDb();
    try {
      await db.insert(
        'favorite',
        {"id": productId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print("SAVE_ENTITIES -> $e");
      return false;
    }
  }

  Future<List<dynamic>> getAll() async {
    final Database db = await _initDb();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM favorite');
    maps.forEach((element) {});
    return List.generate(maps.length, (i) {
      return maps[i];
    });
  }

  Future<int> getCount(String id) async {
    Database db = await _initDb();
    var x =
        await db.rawQuery('SELECT COUNT (*) FROM favorite WHERE id=?', [id]);
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<bool> deleteCurrent(String id) async {
    try {
      final db = await _initDb();
      db.rawQuery("DELETE FROM favorite WHERE id=?", [id]);
      return true;
    } catch (e, trace) {
      print(e);
      return false;
    }
  }
}
