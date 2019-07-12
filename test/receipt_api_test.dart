import 'package:flutter_test/flutter_test.dart';

import 'package:receipt/data/data-api.dart';
import 'package:receipt/data/receipt.dart';



void main() {
  test('Add Receipt', () {
    Receipt receipt = new Receipt(receiptDate: 1001, total: 100);
      ReceiptAPI.add(receipt);
    }
  );

  test('Retrieve Receipt', () {
      Receipt receipt = new Receipt(receiptDate: 1021, total: 100);
      int index = ReceiptAPI.add(receipt);
      Receipt resp = ReceiptAPI.retrieve(index);
      expect(resp.total, receipt.total);
      expect(resp.receiptDate, receipt.receiptDate);
    }
  );

  test('Update Receipt', () {
    Receipt receipt = new Receipt(receiptDate: 13001, total: 100);
      int index = ReceiptAPI.add(receipt);
      
      Receipt update = new Receipt(id: index, receiptDate: 111101, total: 357);

      ReceiptAPI.update(index, update);
      
      Receipt resp = ReceiptAPI.retrieve(index);
      
      expect(resp.total, update.total);
      expect(resp.receiptDate, update.receiptDate);
      
      receipt = update;
    }
  );

  test('Find Receipt', () {
      Receipt receipt = new Receipt(receiptDate: 34002, total: 1369);
      int index = ReceiptAPI.add(receipt);

      List<Receipt> results = ReceiptAPI.find(receipt);
      Receipt resp = results.removeLast();

      expect(resp.id, index);
      expect(resp.total, receipt.total);
      expect(resp.receiptDate, receipt.receiptDate);
    }
  );

  test('Delete Receipt', () {
      Receipt receipt = new Receipt(receiptDate: 1221, total: 100);
      int index = ReceiptAPI.add(receipt);
      ReceiptAPI.delete(index);
      expect(ReceiptAPI.retrieve(index), new List<Receipt>());
    }
  );
}