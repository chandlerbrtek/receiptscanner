import 'package:receipt/data/data-constants.dart';

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
        id: json[ReceiptConstants.RECEIPT_ID],
        total: json[ReceiptConstants.RECEIPT_TOTAL],
        receiptDate: json[ReceiptConstants.RECEIPT_DATE],
        // createDate: json["createDate"],
        // modificationDate: json["modificationDate"],
      );

  Map<String, dynamic> toMap() => {
        ReceiptConstants.RECEIPT_ID: id,
        ReceiptConstants.RECEIPT_TOTAL: total,
        ReceiptConstants.RECEIPT_DATE: receiptDate,
        // "createDate": createDate,
        // "modificationDate": modificationDate,
      };
}
