import 'package:flutter/material.dart';
import 'package:receipt/data/receipt.dart';
import 'package:receipt/data/data-api.dart';

/// The manual entry page is used to gather user input for a receipt. It displays fields for
/// the receipt amount and the receipt date, then stores the data into the database with a
/// new receipt.
class ManualEntryPage {

  /// The key of this form. This can be used for debugging purposes.
  final formKey = GlobalKey<FormState>();

  /// The total value displayed on the form.
  double _total;

  /// The date value displayed on the form.
  DateTime _date;

  /// Controller for the text entry fields.
  final _controller = TextEditingController();

  /// Default initial DateTime of now.
  DateTime selectedDate = DateTime.now();

  /// This method handles the logic of selecting a date, displaying a date
  /// selection tool and recording the selection with the manual entry page.
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _date = selectedDate;
      _controller.text = _date.toString();
    }
  }

  /// This method creates a scaffold for picking a date.
  pickDate(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("date picker"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${selectedDate.toLocal()}"),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
            ),
          ],
        ),
      ),
    );
  }

  /// The entry page widget. This page holds the forms and handles the logic
  /// for creating a receipt object from the data specified within its form.
  /// Then the receipt is added to the database.
  Widget entryPage(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Manual Entry"),
        ),
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Total:'
                    ),
                    autovalidate: true,
                    validator: validateTotal,
                    onSaved: (input) => _total = double.parse(input),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Date:'
                    ),
                    controller: _controller,
                    enabled: true,
                    onChanged: (text) {
                      _controller.text = _date.toString();
                    },
                    cursorWidth: 0,
                    onTap: (){_selectDate(context);},
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
            ),
          ),
        ));
  }

  /// Validate that the total is a properly formatted number.
  String validateTotal(String value) {
    Pattern pattern =
        r'^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid total';
    else
      return null;
  }

  /// Add the receipt to the database.
  void _submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      Receipt receipt = new Receipt(total: (_total * 100).toInt(), receiptDate: _date.millisecondsSinceEpoch);
      ReceiptAPI.add(receipt);
    }
  }
}
