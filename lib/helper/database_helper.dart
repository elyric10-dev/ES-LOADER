import 'package:es_loader/model/inventory.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE inventory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        current_gcash_balance INTEGER NOT NULL,
        mobile_number TEXT NOT NULL,
        deduct_balance INTEGER NOT NULL,
        fee INTEGER NOT NULL,
        total_profit INTEGER NOT NULL,
        new_gcash_balance INTEGER NOT NULL,
        inserted INTEGER NOT NULL,
        number_balance INTEGER NOT NULL,
        timestamp TIMESTAMP NOT NULL,
        transaction_id TEXT NOT NULL,
        has_enquired INTEGER NOT NULL,
        enquire_fixed INTEGER NOT NULL
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'exs_inventory.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print('Creating table...');
        await createTables(database);
      },
    );
  }

// CREATE ITEM
  static Future<int> createItem(Inventory inventory) async {
    final db = await DatabaseHelper.db();

    final id = await db.insert(
      'inventory',
      inventory.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

// GET ALL ITEMS
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query(
      'inventory',
      orderBy: "id",
    );
  }

// GET SPECIFIC ITEM BY ID
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query(
      'inventory',
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
  }

  // UPDATE SPECIFIC ITEM BY ID
  static Future<int> updateItem(int id, Inventory inventory) async {
    final db = await DatabaseHelper.db();

    final result = db.update(
      'inventory',
      inventory.toMap(),
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }

  // DELETE ITEM
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();

    try {
      await db.delete(
        'inventory',
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint(
        "Something went wrong when deleting an item: $e",
      );
    }
  }

  // DROP TABLE
  static Future<void> dropTable(String tableName) async {
    final db = await DatabaseHelper.db();
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  // DROP DATABASE
  static Future<void> dropDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databasePath = join(documentsDirectory.path, 'exs_inventory.db');
    await sql.databaseFactory.deleteDatabase(databasePath);
  }
}
