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
        id: json["id"],
        total: json["total"],
        receiptDate: json["receiptDate"],
        // createDate: json["createDate"],
        // modificationDate: json["modificationDate"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "total": total,
        "receiptDate": receiptDate,
        // "createDate": createDate,
        // "modificationDate": modificationDate,
      };
}
