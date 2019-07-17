import 'package:receipt/data/db.dart';
import 'package:receipt/data/receipt.dart';


/// Add, remove, modify, and retrieve receipts in the database.
class ReceiptAPI {

  /// Add a new receipt to the database.
  /// 
  /// Inserting the new receipt will generate an id. Use this id to retrieve the receipt.
  static add(Receipt receipt) {
    return DatabaseController.insertReceipt(receipt);
  }

  /// Remove a receipt from the database.
  static delete(int index) {
    Receipt receipt = get(index);
    DatabaseController.deleteReceipt(index);
    return receipt;
  }

  /// Update an existing receipt within the database.
  static update(int index, Receipt receipt) {
    DatabaseController.updateReceipt(index, receipt);
  }

  /// Retrieve a receipt from the database.
  static get(int index) {
    return DatabaseController.retrieveReceipt(index);
  }

  /// Retrieve receipts from the database that match the given receipt.
  static find(Receipt receipt) {
    return DatabaseController.retrieveReceiptByFields(receipt);
  }

} 