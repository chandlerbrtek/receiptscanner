import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:receipt/ImagePickerModal.dart';
import 'package:receipt/data/receipt.dart';
import 'package:receipt/data/db.dart';

class ManualEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ManualEntryArgs args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Manual Entry"),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: DateForm(
            total: args.total,
            date: args.date,
          ),
        ),
      ),
    );
  }
}

class DateForm extends StatefulWidget {
  DateForm({Key key, this.total, this.date}) : super(key: key);

  final String total;
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
  String help;

  @override
  void initState() {
    super.initState();

    print('init:');

    _date = DateTime.parse(DateTime.now().toString().substring(0, 10));
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

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Receipt receipt = Receipt(
          total: (_total * 100).toInt(),
          receiptDate: _date.millisecondsSinceEpoch);

      print('Receipt generated:');
      print(receipt.toMap());
      receiptAPI.addReceipt(receipt);

      Navigator.pop(context);
    } else {
      print('Not submitted...');
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
            initialValue: widget.total,
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
                  onPressed: _submit,
                  child: Text('Submit Receipt'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
