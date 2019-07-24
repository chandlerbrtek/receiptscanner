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
        id: json[DatabaseProvider.id],
        total: json[DatabaseProvider.receiptTotal],
        receiptDate: json[DatabaseProvider.receiptDate],
        // createDate: json["createDate"],
        // modificationDate: json["modificationDate"],
      );

  Map<String, dynamic> toMap() => {
        DatabaseProvider.id: id,
        DatabaseProvider.receiptTotal: total,
        DatabaseProvider.receiptDate: receiptDate,
        // "createDate": createDate,
        // "modificationDate": modificationDate,
      };
}

class Budget {
  int id;
  String name;
  int amount;
  int progress;
  int start;
  int end;

  Budget({
    this.id,
    this.name,
    this.amount,
    this.progress,
    this.start,
    this.end,
  });

  factory Budget.fromMap(Map<String, dynamic> budgets) => new Budget(
    id: budgets[DatabaseProvider.id], 
    name: budgets[DatabaseProvider.budgetName],
    amount: budgets[DatabaseProvider.budgetAmount],
    progress: budgets[DatabaseProvider.budgetProgress],
    start: budgets[DatabaseProvider.budgetStart],
    end: budgets[DatabaseProvider.budgetEnd]
  );

  Map<String,dynamic> toMap() => {
    DatabaseProvider.id: id,
    DatabaseProvider.budgetName: name,
    DatabaseProvider.budgetAmount: amount,
    DatabaseProvider.budgetProgress: progress,
    DatabaseProvider.budgetStart: start,
    DatabaseProvider.budgetEnd: end,
  };
}