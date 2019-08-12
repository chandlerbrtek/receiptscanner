import 'package:receipt/data/db.dart';

/// Receipt data object. This object represents a receipt within the
/// application and matches the data definition of the receipt within the database.
class Receipt {

  /// The primary identifier of the receipt within the database. The id should
  /// be created by the database automatically.
  int id;

  /// The total monetary value associated with the receipt.
  int total;

  /// The date of the receipt. This is the receipt's printed date, not the
  /// object's created on or modified on date.
  int receiptDate;

  // int createDate;
  // int modificationDate;

  /// Constructor for the receipt data object.
  Receipt({
    this.id,
    this.total,
    this.receiptDate,
    // this.createDate,
    // this.modificationDate,
  });

  /// Method for creating a receipt from a Map<String, dynamic> representing
  /// this receipt's data.
  factory Receipt.fromMap(Map<String, dynamic> json) => new Receipt(
        id: json[ReceiptDatabaseProvider.id],
        total: json[ReceiptDatabaseProvider.total],
        receiptDate: json[ReceiptDatabaseProvider.date],
        // createDate: json["createDate"],
        // modificationDate: json["modificationDate"],
      );

  /// Method for creating a Map<String, dynamic> representing this receipt's
  /// data.
  Map<String, dynamic> toMap() => {
        ReceiptDatabaseProvider.id: id,
        ReceiptDatabaseProvider.total: total,
        ReceiptDatabaseProvider.date: receiptDate,
        // "createDate": createDate,
        // "modificationDate": modificationDate,
      };
}
