import 'package:es_loader/model/inventory.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE inventory(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        current_gcash_balance INTEGER NOT NULL,
        mobile_number TEXT NOT NULL,
        deduct_balance INTEGER NOT NULL,
        fee INTEGER NOT NULL,
        total_profit INTEGER NOT NULL,
        new_gcash_balance INTEGER NOT NULL,
        inserted INTEGER NOT NULL,
        number_balance INTEGER NOT NULL,
        timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        transaction_id TEXT NOT NULL,
        has_enquired INTEGER NOT NULL,
        enquire_fixed INTEGER NOT NULL
      )
      """).then((value) => print('Created inventory table'));
    ;

    await database.execute("""CREATE TABLE users_balance(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      mobile_number TEXT NOT NULL,
      cash_balance INTEGER NOT NULL,
      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """).then((value) => print('Created users_balance table'));
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'exs_loader.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("Creating database");
        await createTables(database).then(
          (value) => print('Database created'),
        );
      },
    );
  }

  // Create new inventory's item
  static Future<int> createItem(Inventory data) async {
    final db = await SQLHelper.db();

    final id = await db.insert('inventory', data.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// CREATE NEW USER BALANCE
  static Future<int> createUserBalance(String mobileNumber, int balance) async {
    final db = await SQLHelper.db();

    final data = {
      'mobile_number': mobileNumber,
      'cash_balance': balance,
    };

    final id = await db.insert('users_balance', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // READ ALL INVENTORY
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('inventory', orderBy: "id DESC");
  }

  // READ ALL GCASH BALANCE
  static Future<List<Map<String, dynamic>>> getGcashBalance() async {
    final db = await SQLHelper.db();
    return db.query('inventory', orderBy: "id DESC", limit: 1);
  }

  // READ ALL USER BALANCE
  static Future<List<Map<String, dynamic>>> getUserBalance() async {
    final db = await SQLHelper.db();
    return db.query('users_balance', orderBy: "id DESC");
  }

  // READ BALANCE BY NUMBER
  static Future<List<Map<String, dynamic>>> getBalanceByNumber(
      String mobileNumber) async {
    final db = await SQLHelper.db();
    return db.query('users_balance',
        where: "mobile_number = ?", whereArgs: [mobileNumber]);
  }

  // // Read a single item by id
  // // The app doesn't use this method but I put here in case you want to see it
  // static Future<List<Map<String, dynamic>>> getItem(int id) async {
  //   final db = await SQLHelper.db();
  //   return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  // }

  // UPDATE USER BALANCE BY ID
  static Future<int> updateUserBalance(String mobileNumber, int balance) async {
    final db = await SQLHelper.db();

    final data = {
      'mobile_number': mobileNumber,
      'cash_balance': balance,
    };

    final result = await db.update('users_balance', data,
        where: "mobile_number = ?", whereArgs: [mobileNumber]);
    return result;
  }

  // // Delete
  // static Future<void> deleteItem(int id) async {
  //   final db = await SQLHelper.db();
  //   try {
  //     await db.delete("items", where: "id = ?", whereArgs: [id]);
  //   } catch (err) {
  //     debugPrint("Something went wrong when deleting an item: $err");
  //   }
  // }
}
