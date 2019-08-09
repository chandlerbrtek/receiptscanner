import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:receipt/data/models.dart';

/// **Database API**
/// 
/// The receiptAPI is the endpoint for interacting with the Receipt
/// Scanner database. Use this object to modify any data within the application.
final databaseAPI = DatabaseProvider.db;

/// Handles all matters relevant to the database. Creating and
/// accessing the database are handled by the provider. Names
/// for the tables and their fields are also available within the
/// provider. To access the databse, use the [databaseAPI] available
/// within the [db] package.
class DatabaseProvider {
  /// The id label for an entry within the database's tables.
  static const String id = "id";

  /// The label for the receipt table in the database.
  static const String receiptTable = "Receipt";

  /// The total label for a receipt within the receipt table.
  static const String receiptTotal = "total";

  /// The date label for a receipt within the receipt table.
  static const String receiptDate = "receiptDate";

  /// The label for the budget table in the database.
  static const String budgetTable = "budget";

  /// The label for the budget name in the database.
  static const String budgetName = "name";

  /// The label for the budget amount in the database.
  static const String budgetAmount = "amount";

  /// The label for the start date in the database.
  static const String budgetStart = "start";

  /// The label for the end date in the database.
  static const String budgetEnd = "end";

  /// The label for the budget progress in the database.
  static const String budgetProgress = "progress";

  /// Method for singleton instatiation of the DatbaseProvider.
  DatabaseProvider._();

  /// Singleton refernce of the DatabaseProvider for the application.
  static final DatabaseProvider db = DatabaseProvider._();

  /// Private member for holding the database reference.
  Database _database;

  /// Method for retrieving the database instance.
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  /// Provides the database for use within the application.
  /// 
  /// This method handles the connection with the database. It
  /// creates the database when necessary and provides a connection
  /// to an existing database whenever possible.
  static Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "receipt.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $receiptTable ("
            "$id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$receiptTotal INTEGER, "
            "$receiptDate INTEGER"
            // "createDate INTEGER,"
            // "modificationDate INTEGER"
            ");");

        await db.execute("CREATE TABLE $budgetTable ("
            "$id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$budgetName STRING NOT NULL, "
            "$budgetAmount INTEGER NOT NULL, "
            "$budgetStart INTEGER NOT NULL, "
            "$budgetEnd INTEGER NOT NULL, "
            "$budgetProgress INTEGER NOT NULL"
            ");");
        
        _initDatabase(db);
      }
    );
  }

  /// This method fills the database with its initial, pre-loaded data.
  static _initDatabase(Database db) async {
    DateTime startOfYear =  new DateTime(DateTime.now().year, 1, 1);
    DateTime endOfYear = new DateTime(DateTime.now().year + 1, 1, 0);
    DateTime startOfMonth = new DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endOfMonth = new DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    
    await db.insert(
        budgetTable,
        new Budget(
          name: "Annual Budget",
          amount: 120000,
          progress: 0,
          start: startOfYear.millisecondsSinceEpoch,
          end: endOfYear.millisecondsSinceEpoch,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
        
    await db.insert(
        budgetTable,
        new Budget(
          name: "Monthly Budget",
          amount: 10000,
          progress: 0,
          start: startOfMonth.millisecondsSinceEpoch,
          end: endOfMonth.millisecondsSinceEpoch,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
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
      receiptTable,
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
      receiptTable,
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
      receiptTable,
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
    final response = await db.query(receiptTable);
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
      receiptTable,
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
    return db.delete(receiptTable);
  }

  /// **Add Budget**
  /// 
  /// Use this method to add a new budget to the database.
  /// 
  /// The ID will be automatically generated for the budget. If you provide
  /// an id within the [budget], that ID will be used by the database.
  Future<int> addBudget(Budget budget) async {
    final Database db = await database;
    return db.insert(
      budgetTable,
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  /// **Update A Budget**
  /// 
  /// Use this method to update an existing budget within the database.
  /// 
  /// The [budget] needs to contain the id of an existing budget within
  /// the database. Furthermore, the budget in the database with the given
  /// id will be overwritten with all values found on the budget object,
  /// inclusive of null and empty values.
  Future<int> updateBudget(Budget budget) async {
    final db = await database;
    return db.update(
      budgetTable,
      budget.toMap(),
      where: "$id = ?",
      whereArgs: [budget.id],
      );
  }

  /// **Get All Budgets**
  /// 
  /// Use this method to retrieve all budgets from the database.
  /// 
  /// This method queries the budgets table for all budgets and then returns
  /// them in a list sorted by their IDs.
  Future<List<Budget>> getAllBudgets() async {
    final db = await database;
    final response = await db.query(budgetTable, orderBy: id);
    List<Budget> list = response.map((c) => Budget.fromMap(c)).toList();
    return list;
  }

  /// **Delete Budget**
  /// 
  /// Use this method to delete a budget from the database.
  /// 
  /// The [budgetId] must reference the ID of the budget you wish to delete
  /// from the database.
  Future<int> deleteBudget(int budgetId) async {
    final db = await database;
    return db.delete(
      budgetTable,
      where: "$id = ?",
      whereArgs: [budgetId]
    );
  }
}
