import 'package:receipt/data/db.dart';

class Receipt {
  int id;
  int total;
  int receiptDate;
  // int createDate;
  // int modificationDate;

  Receipt({
    this.id,
    this.total,
    this.receiptDate,
    // this.createDate,
    // this.modificationDate,
  });

  factory Receipt.fromMap(Map<String, dynamic> json) => new Receipt(
        id: json[ReceiptDatabaseProvider.id],
        total: json[ReceiptDatabaseProvider.total],
        receiptDate: json[ReceiptDatabaseProvider.date],
        // createDate: json["createDate"],
        // modificationDate: json["modificationDate"],
      );

  Map<String, dynamic> toMap() => {
        ReceiptDatabaseProvider.id: id,
        ReceiptDatabaseProvider.total: total,
        ReceiptDatabaseProvider.date: receiptDate,
        // "createDate": createDate,
        // "modificationDate": modificationDate,
      };
}
