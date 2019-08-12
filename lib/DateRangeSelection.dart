import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import './pages/report_pages.dart';

class DateRangeSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Date Range"),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: DateForm(
            startDate: DateTime.parse(DateTime.now().toString().substring(0, 10)),
            endDate: DateTime.parse(DateTime.now().toString().substring(0, 10))
          ),
        ),
      ),
    );
  }
}

class DateForm extends StatefulWidget {
  DateForm({Key key, this.startDate, this.endDate}) : super(key: key);

  final DateTime startDate;
  final DateTime endDate;

  @override
  _DateFormState createState() => _DateFormState();
}

class _DateFormState extends State<DateForm> {
  final _formKey = GlobalKey<FormState>();

  static final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  DateTime _sDate;
  DateTime _eDate;

  @override
  void initState() {
    super.initState();

    _sDate = widget.startDate ?? DateTime.now();
    _eDate = widget.endDate ?? DateTime.now();

    _startController.text = dateFormat.format(_sDate);
    _endController.text = dateFormat.format(_eDate);
  }

  Future<Null> _selectSDate(BuildContext context) async {
    //https://github.com/flutter/flutter/issues/7247#issuecomment-348269522
    //https://stackoverflow.com/a/44991969
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _sDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));

    if (picked != null && picked != _sDate) {
      print('date selected: $picked');

      setState(() => _sDate = picked);
      _startController.text = dateFormat.format(_sDate);
    }
  }

  Future<Null> _selectEDate(BuildContext context) async {
    //https://github.com/flutter/flutter/issues/7247#issuecomment-348269522
    //https://stackoverflow.com/a/44991969
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _eDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2020));

    if (picked != null && picked != _eDate) {
      print('date selected: $picked');

      setState(() => _eDate = picked);
      _endController.text = dateFormat.format(_eDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Start Date:'),
            controller: _startController,
            enabled: true,
            cursorWidth: 0,
            onTap: () => _selectSDate(context),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'End Date:'),
            controller: _endController,
            enabled: true,
            cursorWidth: 0,
            onTap: () => _selectEDate(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new Report_pages("custom", _sDate.millisecondsSinceEpoch, _eDate.millisecondsSinceEpoch))),
                  child: Text('Get Report'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
