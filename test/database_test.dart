
import 'package:flutter_test/flutter_test.dart';

import 'package:receipt/data/db.dart';
import 'package:receipt/data/receipt.dart';

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// **Receipt Database Test Suite**
/// 
/// This program runs all database tests for the Receipt Scanner application. To run
/// the tests, user flutter to run this main method. Flutter will automatically build
/// the application and prepare the database for testing.
/// 
/// ***Note***: The database runs from the user documents directory on Android / iOS
/// and thereby requires that the tests are run against an active instance of the
/// application.
void main() {
  clearDatabase() async {
    await receiptAPI.deleteAllReceipts();
    print('Database cleared');
  }

  deleteDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "receipt.db");
    deleteDatabase(path);
    print('Database Deleted!');
  }

  // deleteDB();
  clearDatabase();


  test('Add Receipt Test - Auto ID', () async {
    Receipt receipt = new Receipt(total: 101, receiptDate: 10001);
    Receipt addResponse = await receiptAPI.addReceipt(receipt);

    expect(addResponse.total, receipt.total, reason: 'Response total does not match argued total');
    expect(addResponse.receiptDate, receipt.receiptDate, reason: 'Response date does not match aruged date');

    if (addResponse.id <= 0) fail('Receipt id is negative');
  });

  test('Add Receipt - Defined ID', () async {
    Receipt receipt = new Receipt(id: 2, total: 102, receiptDate: 10002);
    Receipt addResponse = await receiptAPI.addReceipt(receipt);

    expect(addResponse.id, receipt.id, reason: 'Response id does not match the argued id');
    expect(addResponse.total, receipt.total, reason: 'Response total does not match argued total');
    expect(addResponse.receiptDate, receipt.receiptDate, reason: 'Response date does not match aruged date');
  });

  test('Get Receipt - Auto ID', () async {
    Receipt receipt = new Receipt(receiptDate: 10003, total: 103);
    Receipt add = await receiptAPI.addReceipt(receipt);
    Receipt retrieve = await receiptAPI.getReceipt(add.id);

    expect(retrieve.receiptDate, receipt.receiptDate, reason: 'Response date does not match aruged date');
    expect(retrieve.total, receipt.total, reason: 'Response total does not match argued total');
  });

  test('Get Receipt - Defined ID', () async {
    Receipt receipt = new Receipt(id: 3, receiptDate: 10004, total: 104);
    await receiptAPI.addReceipt(receipt);
    Receipt retrieve = await receiptAPI.getReceipt(receipt.id);

    expect(retrieve.receiptDate, receipt.receiptDate, reason: 'Response date does not match aruged date');
    expect(retrieve.total, receipt.total, reason: 'Response total does not match argued total');
  });

  test('Get Receipt - Bad ID', () async {
    Receipt response = await receiptAPI.getReceipt(-101);

    expect(response, null, reason: 'Found receipt with negative id');
  });

  test('Update Receipt - Auto ID', () async {
    Receipt receipt = new Receipt(total: 105, receiptDate: 10005);
    Receipt add = await receiptAPI.addReceipt(receipt);

    Receipt update = new Receipt(id: add.id, total: 55, receiptDate: add.receiptDate);
    int numUpdates = await receiptAPI.updateReceipt(update);
    expect(numUpdates, 1, reason: 'Updated number of records was not 1');

    Receipt updateResponse = await receiptAPI.getReceipt(add.id);

    expect(updateResponse.total, 55, reason: 'Receipt total did not match the updated total');
    expect(updateResponse.receiptDate, receipt.receiptDate, reason: 'Receipt date did not match the original date');
  });

  test('Update Receipt - Defined ID', () async {
    Receipt receipt = new Receipt(id: 6, total: 106, receiptDate: 10006);
    Receipt add = await receiptAPI.addReceipt(receipt);

    Receipt update = new Receipt(id: receipt.id, total: 65, receiptDate: add.receiptDate);
    int numUpdates = await receiptAPI.updateReceipt(update);
    expect(numUpdates, 1, reason: 'There should only be one receipt with ID = ' + receipt.id.toString());
    
    Receipt updateResponse = await receiptAPI.getReceipt(receipt.id);
    
    expect(updateResponse.total, 65);
    expect(updateResponse.receiptDate, receipt.receiptDate);
  });

  test('Delete Receipt - Auto ID', () async {
    Receipt receipt = new Receipt(total: 107, receiptDate: 10007);
    Receipt add = await receiptAPI.addReceipt(receipt);

    int numDeleted = await receiptAPI.deleteReceipt(add.id);
    expect(numDeleted, 1, reason: 'There should only be one receipt with ID = ' + receipt.id.toString());
  });

  test('Delete Receipt - Defined ID', () async {
    Receipt receipt = new Receipt(id: 8, total: 108, receiptDate: 10008);
    await receiptAPI.addReceipt(receipt);
    int numDeleted = await receiptAPI.deleteReceipt(receipt.id);
    expect(numDeleted, 1, reason: 'There should only be one receipt with ID = ' + receipt.id.toString() );
  });

  test('Delete All Receipts', () async {
    await receiptAPI.deleteAllReceipts();
    receiptAPI.addReceipt(new Receipt(receiptDate: 10009, total: 109));
    receiptAPI.addReceipt(new Receipt(receiptDate: 10010, total: 110));
    int numRemoved = await receiptAPI.deleteAllReceipts();
    expect(numRemoved, 2, reason: 'Failed to remove all receipts');
    expect(await receiptAPI.deleteAllReceipts(), 0, reason: 'Database should be empty');
  });
}