import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:receipt/data/models.dart';
import 'package:receipt/data/db.dart';

class EditEntryPage extends StatelessWidget {
  final Receipt receipt;
  EditEntryPage({Key key, @required this.receipt}) : super(key: key);

  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Entry"),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: DateForm(
            receipt: receipt,
            total:
                formatCurrency.format(receipt.total / 100).replaceAll("\$", ""),
            date: DateTime.fromMillisecondsSinceEpoch(receipt.receiptDate),
          ),
        ),
      ),
    );
  }
}

class DateForm extends StatefulWidget {
  DateForm({Key key, this.total, this.date, this.receipt}) : super(key: key);

  final String total;
  final Receipt receipt;
  final DateTime date;

  @override
  _DateFormState createState() => _DateFormState();
}

class _DateFormState extends State<DateForm> {
  final _formKey = GlobalKey<FormState>();

  static final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final TextEditingController _controller = TextEditingController();

  DateTime _date;
  double _total;

  @override
  void initState() {
    super.initState();

    print('init:');
    print(widget.date);

    _date = widget.date ?? DateTime.now();
    _controller.text = dateFormat.format(_date);
  }

  Future<Null> _selectDate(BuildContext context) async {
    //https://github.com/flutter/flutter/issues/7247#issuecomment-348269522
    //https://stackoverflow.com/a/44991969
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));

    if (picked != null && picked != _date) {
      print('date selected: $picked');

      setState(() => _date = picked);
      _controller.text = dateFormat.format(_date);
    }
  }

  String _validateTotal(String value) {
    Pattern pattern = r'^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid total';
    else
      return null;
  }

  void _update() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Receipt receipt = Receipt(
          id: widget.receipt.id,
          total: (_total * 100).toInt(),
          receiptDate: _date.millisecondsSinceEpoch);

      print('Receipt generated:');
      print(receipt.toMap());
      databaseAPI.updateReceipt(receipt);

      Navigator.pop(context);
    } else {
      print('Not updated...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            initialValue: widget.total.replaceAll(',', ''),
            decoration: InputDecoration(labelText: 'Total:'),
            autovalidate: true,
            validator: _validateTotal,
            onSaved: (input) => setState(() => _total = double.parse(input)),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Date:'),
            controller: _controller,
            enabled: true,
            cursorWidth: 0,
            onTap: () => _selectDate(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: _update,
                  child: Text('Update Receipt'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
