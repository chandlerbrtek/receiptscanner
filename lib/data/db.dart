import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:receipt/data/receipt.dart';

final receiptAPI = ReceiptDatabaseProvider.db;

class ReceiptDatabaseProvider {
  /// The label for the receipt table in the database.
  static const String table = "Receipt";

  /// The id label for a receipt within the receipt table.
  static const String id = "id";

  /// The total label for a receipt within the receipt table.
  static const String total = "total";

  /// The date label for a receipt within the receipt table.
  static const String date = "receiptDate";

  ReceiptDatabaseProvider._();

  static final ReceiptDatabaseProvider db = ReceiptDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  static Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "receipt.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $table ("
            "$id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$total INTEGER, "
            "$date INTEGER"
            // "createDate INTEGER,"
            // "modificationDate INTEGER"
            ");");
      },
    );
  }

  Future<Receipt> addReceipt(Receipt receipt) async {
    final db = await database;
    receipt.id = await db.insert(
      table,
      receipt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return receipt;
  }

  Future<int> updateReceipt(Receipt receipt) async {
    final db = await database;
    return await db.update(
      table,
      receipt.toMap(),
      where: "$id = ?",
      whereArgs: [receipt.id],
    );
  }

  Future<Receipt> getReceipt(int getId) async {
    final db = await database;
    final response = await db.query(
      table,
      where: "$id = ?",
      whereArgs: [getId],
    );
    return response.isNotEmpty ? Receipt.fromMap(response.first) : null;
  }

  Future<List<Receipt>> getAllReceipts() async {
    final db = await database;
    final response = await db.query(table);
    List<Receipt> list = response.map((c) => Receipt.fromMap(c)).toList();
    list.sort((a, b) => b.receiptDate - a.receiptDate);
    return list;
  }

  Future<int> deleteReceipt(int deleteId) async {
    final db = await database;
    return db.delete(
      table,
      where: "$id = ?",
      whereArgs: [deleteId],
    );
  }

  Future<int> deleteAllReceipts() async {
    final db = await database;
    return db.delete(table);
  }
}
