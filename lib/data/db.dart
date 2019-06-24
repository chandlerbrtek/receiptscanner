import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:receipt/data/receipt.dart';
import 'package:receipt/data/data-constants.dart';


class ReceiptDatabaseProvider {
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
            ");"
        );
      },
    );
  }

  static String table = ReceiptConstants.RECEIPT_TABLE;
  static String id = ReceiptConstants.RECEIPT_ID;
  static String total = ReceiptConstants.RECEIPT_TOTAL;
  static String date = ReceiptConstants.RECEIPT_DATE;

}

class DatabaseController {

  /// Insert a new receipt into the database.
  /// 
  /// The database will automatically assign the receipt a new id, then return that value as an integer.
  ///   
  /// **return** the id of the new receipt
  static insertReceipt(Receipt receipt) {
    ReceiptDatabaseProvider.db.database.then((value) {
      value.insert(
        ReceiptConstants.RECEIPT_TABLE, receipt.toMap()).then((value) {
          return value;  
        }
      );
    });
  }

  /// Delete a receipt from the database.
  /// 
  /// Deletes the receipt found at the given index.
  /// If more than one receipt was deleted at the given index, this method will throw an exception.
  /// 
  /// **return** the number of deleted receipts
  /// 
  /// **throws** REceiptDatabaseException when more than one Receipt is deleted.
  static deleteReceipt(int index) {
    Future<int> i;
    ReceiptDatabaseProvider.db.database.then((value) {
        i = value.delete(
          ReceiptConstants.RECEIPT_TABLE, where:
          ReceiptConstants.RECEIPT_ID + " = " + index.toString());
        
    });
    i.then((value) {
      return value;
    });
  }

  /// Retrive a receipt from the database.
  /// 
  /// Find a receipt with the given index (id) within the database and return it.
  /// 
  /// **returns** The receipt found at the given index, if there was one.
  /// 
  /// **throws**  ReceiptDatabaseException when more than one Receipt is found for the given index.
  static retrieveReceipt(int index) {
    Future<List<Map<String, dynamic>>> i;
    ReceiptDatabaseProvider.db.database.then((value) {
      i = value.query(
        ReceiptConstants.RECEIPT_TABLE, where:
        ReceiptConstants.RECEIPT_ID + " = " + index.toString());
        
    });
    i.then((value) {
          List<Receipt> results = new List<Receipt>();
          for (Map<String, dynamic> result in value) {
            results.add(Receipt.fromMap(result));
          }
          if (results.length > 1) throw new ReceiptDatabaseException(
            "Multiple records found for the " + ReceiptConstants.RECEIPT_ID + " " + index.toString()
            );
          return results;
        }
      );
  }

  /// Retrieve all receipts that match the given receipt.
  /// 
  /// This method will search the database for receipts that match all of the provided
  /// receipt's populted fields, then return them as a list of Receipts.
  /// 
  /// **returns** List<Receipt> the matching receipts.
  static retrieveReceiptByFields(Receipt receipt) {
    Future<List<Map<String, dynamic>>> i;
    ReceiptDatabaseProvider.db.database.then((value) {
      i = value.query(
        ReceiptConstants.RECEIPT_TABLE, where:
        ReceiptConstants.RECEIPT_TOTAL + " = '" + receipt.total.toString() + "' AND " +
        ReceiptConstants.RECEIPT_DATE + " = " + receipt.receiptDate.toString() + ""
      );
    });
    i.then((value) {
        List<Receipt> results = new List<Receipt>();
        for (Map<String, dynamic> result in value) {
          results.add(Receipt.fromMap(result));
        }
        return results;
      });
  }

  /// Update the receipt at the given index.
  /// 
  /// This method updates receipts that match the given index to hold the give values.
  static updateReceipt(int index, Receipt receipt) {
    ReceiptDatabaseProvider.db.database.then((value) {
      value.update(
        ReceiptConstants.RECEIPT_TABLE, receipt.toMap(), where:
        ReceiptConstants.RECEIPT_ID + " = " + index.toString()
      ).then((value) {
        return value;
      });
    });
  }
}
/// Exception caused by database communication issues or general misbehavior.
class ReceiptDatabaseException extends DatabaseException {
  ReceiptDatabaseException(String message) : super(message);
}