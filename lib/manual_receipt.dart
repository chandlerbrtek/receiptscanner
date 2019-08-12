import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:receipt/ImagePickerModal.dart';
import 'package:receipt/data/models.dart';
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
            prices: args.prices,
            date: args.date,
          ),
        ),
      ),
    );
  }
}

class DateForm extends StatefulWidget {
  DateForm({Key key, this.prices, this.date}) : super(key: key);

  final List<String> prices;
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
  String selectedPrice;
  List<Widget> dropdownOptions;
  String help;

  @override
  void initState() {
    super.initState();

    print('init:');

    if (widget.prices != null) {
      this.selectedPrice = widget.prices.last;
      this.dropdownOptions = widget.prices
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList();
    }
    _date = widget.date ?? DateTime.now();
    _controller.text = dateFormat.format(_date);
  }

  /// This method handles the logic of selecting a date, displaying a date
  /// selection tool and recording the selection with the manual entry page.
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

  /// Add the receipt to the database.
  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Receipt receipt = Receipt(
          total: (_total * 100).toInt(),
          receiptDate: _date.millisecondsSinceEpoch);

      print('Receipt generated:');
      print(receipt.toMap());
      databaseAPI.addReceipt(receipt);

      Navigator.pop(context);
    } else {
      print('Not submitted...');
    }
  }

  Widget totalWidget() {
    if (widget.prices == null)
      return TextFormField(
        decoration: InputDecoration(labelText: 'Total:'),
        autovalidate: true,
        validator: _validateTotal,
        onSaved: (input) => setState(() => _total = double.parse(input)),
      );
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: 'Total',
          prefixText: '\$',
        ),
        value: this.selectedPrice,
        items: dropdownOptions,
        onChanged: (input) => setState(() => this.selectedPrice = input),
        onSaved: (input) => setState(() => _total = double.parse(input)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          totalWidget(),
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
