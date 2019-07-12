import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:receipt/data/data-api.dart';
import 'package:receipt/data/receipt.dart';

int index = Random(TimeOfDay.now().minute).nextInt(100000) + 10000;

void main() {
  test('Add Receipt', () {
      int date = 1001, total = 100;
      print('Adding Receipt:\nid:\t$index\nreceiptDate:\t$date\ntotal:\t$total');
      ReceiptAPI.add(new Receipt(id: index, receiptDate: date, total: total));
    }
  );
}