import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:receipt/data/models.dart';
import 'package:receipt/data/db.dart';

/// Viewer model for editing a receipt entry.
class EditEntryPage extends StatelessWidget {

  /// The receipt data for the editing process.
  final Receipt receipt;

  /// Constructor for an editing page.
  EditEntryPage({Key key, @required this.receipt}) : super(key: key);

  /// Formatter for rendering the total amount.
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

/// Date form editing a receipt object.
class DateForm extends StatefulWidget {

  /// Date form constructor.
  DateForm({Key key, this.total, this.date, this.receipt}) : super(key: key);

  /// The total for the receipt.
  final String total;

  /// The receipt object being edited.
  final Receipt receipt;

  /// The date for the receipt.
  final DateTime date;

  @override
  _DateFormState createState() => _DateFormState();
}

/// State of the receipt. This allows for the receipt form to be updated
/// dynamically.
class _DateFormState extends State<DateForm> {

  /// Key for identifying the state.
  final _formKey = GlobalKey<FormState>();

  /// Formatter for rendering the receipt date.
  static final dateFormat = DateFormat("EEEE, MMMM d, yyyy");

  /// Controller for handling the receipt's date field.
  final TextEditingController _controller = TextEditingController();

  /// The date for the receipt field.
  DateTime _date;

  /// The total for the receipt field.
  double _total;

  @override
  void initState() {
    super.initState();

    print('init:');
    print(widget.date);

    _date = widget.date ?? DateTime.now();
    _controller.text = dateFormat.format(_date);
  }

  /// Function for selecting a date. Uses a date picker model
  /// and updates the selected date value.
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

  /// Validate that the total is a proper double string.
  String _validateTotal(String value) {
    Pattern pattern = r'^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid total';
    else
      return null;
  }

  /// Update the receipt object. Send the modified receipt values to the
  /// database.
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
