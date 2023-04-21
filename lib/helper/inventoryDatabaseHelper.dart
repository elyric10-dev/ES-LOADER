import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:es_loader/model/inventory.dart';

class InventoryDatabaseHelper {
  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE inventory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            current_balance INTEGER NOT NULL,
            mobile_number TEXT NOT NULL,
            deduct_balance INTEGER NOT NULL,
            fee INTEGER NOT NULL,
            total_profit INTEGER NOT NULL,
            new_balance INTEGER NOT NULL,
            inserted INTEGER NOT NULL,
            number_balance INTEGER NOT NULL,
            timestamp TEXT NOT NULL,
            transaction_id TEXT NOT NULL,
            has_enquired INTEGER NOT NULL,
            enquire_fixed INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}
