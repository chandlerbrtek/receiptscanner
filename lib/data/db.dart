import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptDatabaseProvider {
  ReceiptDatabaseProvider._();

  static final ReceiptDatabaseProvider db = ReceiptDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "receipt.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Receipt ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "total INTEGER,"
            "receiptDate INTEGER"
            // "createDate INTEGER,"
            // "modificationDate INTEGER"
            ")");
      },
    );
  }
}
