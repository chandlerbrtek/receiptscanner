import 'package:flutter/material.dart';
import 'package:receipt/ImagePickerModal.dart';
import 'package:receipt/data/receipt.dart';
import 'package:receipt/data/data-api.dart';

class ManualEntryPage {
  static final formKey = GlobalKey<FormState>();
  double _total;
  DateTime _date;

  final _controller = TextEditingController();

  DateTime selectedDate = DateTime.now();

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

  Widget entryPage(BuildContext context) {
    final ManualEntryArgs args =
        ModalRoute.of(context).settings.arguments;

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
                    initialValue: args.total,
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

  String validateTotal(String value) {
    Pattern pattern =
        r'^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid total';
    else
      return null;
  }

  void _submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      Receipt receipt = new Receipt(total: (_total * 100).toInt(), receiptDate: _date.millisecondsSinceEpoch);
      ReceiptAPI.add(receipt);
    }
  }
}
