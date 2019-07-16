import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:receipt/data/receipt.dart';

/// **Receipt API**
/// 
/// The receiptAPI is the endpoint for interacting with the Receipt
/// Scanner database. Use this object to modify any data with the application.
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

  /// **Add Receipt**
  /// 
  /// Use this method to add a new receipt to the database.
  /// 
  /// When adding a receipt, the database will automatically assign
  /// a new id for the receipt. This id is returned on the response
  /// receipt object.
  /// 
  /// ***Note***: If an id is specified and another receipt with the same
  /// id is specified within the database, that receipt will be overwritten
  /// by the new receipt. The update method should be used in such a scenario.
  /// 
  /// ***Example***
  /// 
  /// addReceipt ( {
  ///   "total" : 508,
  ///   "receiptDate" : 15003
  /// }) 
  /// 
  /// Returns the receipt
  /// 
  /// {
  ///   "id" : 37872,
  ///   "total" : 508,
  ///   "receiptDate" : 15003
  /// }
  /// 
  /// Where the id is the next available id in the database.
  Future<Receipt> addReceipt(Receipt receipt) async {
    final db = await database;
    receipt.id = await db.insert(
      table,
      receipt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return receipt;
  }

  /// **Update Receipt**
  /// 
  /// Use this method to update a receipt in the database.
  /// 
  /// To update a receipt, the receipt id in the argued receipt object
  /// must match the id of the desired receipt to update. The target receipt
  /// in the database will be updated to the exact values of the values of
  /// the argued receipt object, inclusive of nulls.
  /// 
  /// ***Example***
  /// 
  /// For an existing receipt {
  ///   "id" : 101,
  ///   "total" : 2800,
  ///   "receiptDate" : 89000
  /// }
  /// 
  /// When updateReceipt is called with the argument {
  ///   "id" : 101,
  ///   "total" 2799
  /// }
  /// 
  /// The updated receipt in the database will be {
  ///   "id" : 101,
  ///   "total" : 2799,
  ///   "receiptDate" : null
  /// }
  Future<int> updateReceipt(Receipt receipt) async {
    final db = await database;
    return await db.update(
      table,
      receipt.toMap(),
      where: "$id = ?",
      whereArgs: [receipt.id],
    );
  }

  /// **Get Receipt**
  /// 
  /// Use this method to retrieve a receipt from the database.
  /// 
  /// To retrieve a receipt from the database, you must specify
  /// the id of the receipt.
  Future<Receipt> getReceipt(int getId) async {
    final db = await database;
    final response = await db.query(
      table,
      where: "$id = ?",
      whereArgs: [getId],
    );
    return response.isNotEmpty ? Receipt.fromMap(response.first) : null;
  }

  /// **Get All Receipts**
  /// 
  /// Use this method to retrieve a list of all receipts in the database.
  /// 
  /// This method gathers the entire list of receipts found in the database and
  /// returns them in a list ordered by the date of the receipt.
  Future<List<Receipt>> getAllReceipts() async {
    final db = await database;
    final response = await db.query(table);
    List<Receipt> list = response.map((c) => Receipt.fromMap(c)).toList();
    list.sort((a, b) => b.receiptDate - a.receiptDate);
    return list;
  }

  /// **Delete Receipt**
  /// 
  /// Use this method to delete a receipt from the database.
  /// 
  /// To delete a receipt from the database, you must specify the
  /// id of the receipt.
  Future<int> deleteReceipt(int deleteId) async {
    final db = await database;
    return db.delete(
      table,
      where: "$id = ?",
      whereArgs: [deleteId],
    );
  }

  /// **Delete All Receipts**
  ///
  /// Use this method to delete all receipts in the database.
  /// 
  /// This method will remove every receipt from the database,
  /// and therefore should only be done conscientiously.
  Future<int> deleteAllReceipts() async {
    final db = await database;
    return db.delete(table);
  }
}
