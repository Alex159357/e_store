import 'package:e_store/data/models/cart_model.dart';
import 'package:e_store/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDb {
  _initDb() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'cart.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE cart(id TEXT PRIMARY KEY, count INTEGER, color TEXT, size TEXT)");
      },
      version: 1,
    );
    return db;
  }

  Future<bool> insertProduct(CartModel product) async {
    final Database db = await _initDb();
    try {
      await db.insert(
        'cart',
        product.toJson,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print("SAVE_ENTITIES -> $e");
      return false;
    }
  }

  Future<List<CartModel>> getById(String id) async {
    final Database db = await _initDb();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM cart WHERE id = ?', ["$id"]);
    maps.forEach((element) {
      print("MAPFROMDB -> ${element["fields"]}");
    });
    return List.generate(maps.length, (i) {
      return CartModel.fromJson(maps[i]);
    });
  }

  Future<int> getCount(String id) async {
    Database db = await _initDb();
    var x = await db.rawQuery('SELECT COUNT (*) FROM cart WHERE id=?', [id]);
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<bool> deleteCurrent(String id) async {
    try {
      final db = await _initDb();
      db.rawQuery("DELETE FROM cart WHERE id=?", [id]);
      return true;
    } catch (e, trace) {
      print(e);
      return false;
    }
  }
}
