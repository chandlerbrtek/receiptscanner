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
        id: json[DatabaseProvider.id],
        total: json[DatabaseProvider.receiptTotal],
        receiptDate: json[DatabaseProvider.receiptDate],
        // createDate: json["createDate"],
        // modificationDate: json["modificationDate"],
      );

  /// Method for creating a Map<String, dynamic> representing this receipt's
  /// data.
  Map<String, dynamic> toMap() => {
        DatabaseProvider.id: id,
        DatabaseProvider.receiptTotal: total,
        DatabaseProvider.receiptDate: receiptDate,
        // "createDate": createDate,
        // "modificationDate": modificationDate,
      };
}

/// Budget data object. This class contains the data and the model for the budget
/// object in the receipt scanner application.
class Budget {

  /// The primary identifier for the budget within the database. This value is
  /// automatically assigned on insert unless otherwise specified.
  int id;

  /// The name of the budget. The name is customizable and should be a friendly
  /// identifier for the user.
  String name;

  /// The budget amount. This is the upper cap for the budget.
  int amount;

  /// The budget progress. This is the amount of spending that has occurred
  /// within the bounds of this budget.
  int progress;

  /// The start date for the budget.
  int start;

  /// The end date for the budget.
  int end;

  /// Budget constructor. The database will accept nulls for any of the values.
  Budget({
    this.id,
    this.name,
    this.amount,
    this.progress,
    this.start,
    this.end,
  });

  /// Factory method for creating a budget object from a map. Use this for converting
  /// a database response into a budget object.
  factory Budget.fromMap(Map<String, dynamic> budgets) => new Budget(
    id: budgets[DatabaseProvider.id], 
    name: budgets[DatabaseProvider.budgetName],
    amount: budgets[DatabaseProvider.budgetAmount],
    progress: budgets[DatabaseProvider.budgetProgress],
    start: budgets[DatabaseProvider.budgetStart],
    end: budgets[DatabaseProvider.budgetEnd]
  );

  /// Method for converting the budget into a mapping of labels to values. Use this
  /// for converting the budget object into data usable by the database.
  Map<String,dynamic> toMap() => {
    DatabaseProvider.id: id,
    DatabaseProvider.budgetName: name,
    DatabaseProvider.budgetAmount: amount,
    DatabaseProvider.budgetProgress: progress,
    DatabaseProvider.budgetStart: start,
    DatabaseProvider.budgetEnd: end,
  };
}