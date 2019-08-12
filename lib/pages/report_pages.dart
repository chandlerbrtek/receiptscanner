import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:receipt/data/db.dart';
import 'package:receipt/data/models.dart';

/// The Report_pages serve as the view model for reports. All
/// report types are displayed using the this model.
class Report_pages extends StatelessWidget {

  /// The font size for small text.
  final double _smallFontSize = 12;

  /// The font size for the value.
  final double _valFontSize = 30;

  /// The font weight for the the small text.
  final FontWeight _smallFontWeight = FontWeight.w500;

  /// The font weight for the value.
  final FontWeight _valFontWeight = FontWeight.w700;

  /// The font color for the report.
  final Color _fontColor = Color(0xffffffff);

  /// The spacing for the small text.
  final double _smallFontSpacing = 1.3;

  /// The backgrouind color for the report page.
  final Color _backgroundColor = Color(0xff30303);

  /// The current datetime.
  static final DateTime _dateTime = DateTime.now();

  /// The last day of each month.
  static final List<int> finalDayOfMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  /// The first day of the  current year.
  final int _beginYear = DateTime(_dateTime.year, 1, 1, 0, 0, 0, 0, 0).millisecondsSinceEpoch;

  /// The last day of the current year.
  final int _endYear = DateTime(_dateTime.year + 1, 1, 1, 0, 0, 0, 0, 0).millisecondsSinceEpoch;

  /// The first day of the current month.
  final int _beginMonth = DateTime(_dateTime.year, _dateTime.month, 1, 0, 0, 0, 0, 0).millisecondsSinceEpoch;

  /// The last day of the current month.
  final int _endMonth = DateTime(_dateTime.year, _dateTime.month, finalDayOfMonth[_dateTime.month - 1], 0, 0, 0, 0, 0).millisecondsSinceEpoch;
  
  /// The style for the report page header.
  final headerStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xffffffff));

  /// The name of the page state.
  final String state;

  /// The value for the report start range.
  final int customStart;

  /// The value for the report end range.
  final int customEnd;

  /// Constructor for creating the report page.
  Report_pages(this.state, this.customStart, this.customEnd);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: new Container(
        decoration: new BoxDecoration(color: _backgroundColor),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("TOTAL",
                        style: TextStyle(
                          fontWeight: _smallFontWeight,
                          fontSize: _smallFontSize,
                          letterSpacing: _smallFontSpacing,
                          color: _fontColor,
                        )),
                    SizedBox(height: 10),
                    Text("Sum",
                        style: TextStyle(
                          fontWeight: _valFontWeight,
                          fontSize: _valFontSize,
                          color: _fontColor,
                        )),
                    SizedBox(height: 30),
                    Text("Count of entries",
                        style: TextStyle(
                          fontWeight: _smallFontWeight,
                          fontSize: _smallFontSize,
                          letterSpacing: _smallFontSpacing,
                          color: _fontColor,
                        )),
                    SizedBox(height: 10),
                    Text("6.45h",
                        style: TextStyle(
                          fontWeight: _valFontWeight,
                          fontSize: _valFontSize,
                          color: _fontColor,
                        )),
                  ],
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Color(0xff525252),
                      border: Border.all(
                        width: 8,
                        color: Color(0xffd3e1ed),
                      ),
                      borderRadius: BorderRadius.circular(3)),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        state.toUpperCase(),
                        style: TextStyle(
                            fontSize: _smallFontSize,
                            fontWeight: _smallFontWeight,
                            letterSpacing: _smallFontSpacing,
                            color: _fontColor),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 120,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: CustomPaint(
                          foregroundPainter: GraphPainter(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),

            ///State will dictate type of database query
            ///
            ///Recent will search within a weeks time
            if (state == "recent")
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[Text('recent', style: headerStyle)],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[Expanded(child: RecentReceipts())],
                  ),
                ],
              ),

            ///Month will search within the month
            if (state == "month")
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[Text('month', style: headerStyle)],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[Expanded(child: ReceiptsInRange(start: _beginMonth, end: _endMonth))],
                  ),
                ],
              ),

              ///Year will search within the year
            if (state == "year")
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[Text('year', style: headerStyle)],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[Expanded(child: ReceiptsInRange(start: _beginYear, end: _endYear))],
                  ),
                ],
              ),

            ///Year will search within a custom range
            if (state == "custom")
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[Text('custom', style: headerStyle)],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[Expanded(child: ReceiptsInRange(start: customStart, end: customEnd))],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// View model for the recent receipts body.
class RecentReceipts extends StatelessWidget {
  
  const RecentReceipts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Receipt>>(
        future: databaseAPI.getAllReceipts(),
        builder: (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    _Receipt(receipt: snapshot.data[index]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

/// View model for a list of receipts within a report range.
class ReceiptsInRange extends StatelessWidget {
  const ReceiptsInRange({
    Key key,
    int start,
    int end
  }) : _start = start,
        _end = end,
        super(key: key);

  /// Report range start date.
  final int _start;

  /// Report range end date.
  final int _end;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Receipt>>(
        future: databaseAPI.getReceiptsInRange(_start, _end),
        builder: (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    _Receipt(receipt: snapshot.data[index]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

/// View model for a receipt in the report body.
class _Receipt extends StatelessWidget {

  /// The receipt data for this model.
  final Receipt receipt;

  /// The text style for this model.
  final textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.3,
      color: Color(0xff5b6990));

  /// The formatting for the date of this model.
  final dateFormat = DateFormat("MM/dd/yyyy");

  /// The formatting for thie currency of this model.
  final formatCurrency = new NumberFormat.simpleCurrency();

  /// View model constructor. The receipt must be provided for
  /// the model.
  _Receipt({Key key, @required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(receipt.receiptDate);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffdde9f7),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            dateFormat.format(date),
            style: textStyle,
          ),
          SizedBox(
            width: 25,
          ),
          Expanded(
            child: Text(
              formatCurrency.format(receipt.total / 100),
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }
}

/// Graph painter for the cutstom graph on the report page.
class GraphPainter extends CustomPainter {
  //the one in the foreground
  Paint trackBarPaint = Paint()
    ..color = Color(0xff818aab)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12;

  //the one in the background
  Paint trackPaint = Paint()
    ..color = Color(0xffdee6f1)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12;

  @override
  void paint(Canvas canvas, Size size) {
    List val = [
      size.height * 0.8,
      size.height * 0.5,
      size.height * 0.9,
      size.height * 0.8,
      size.height * 0.5,
    ];
    double origin = 8;

    Path trackBarPath = Path();
    Path trackPath = Path();

    for (int i = 0; i < val.length; i++) {
      trackPath.moveTo(origin, size.height);
      trackPath.lineTo(origin, 0);

      trackBarPath.moveTo(origin, size.height);
      trackBarPath.lineTo(origin, val[i]);

      origin = origin + size.width * 0.22;
    }

    canvas.drawPath(trackPath, trackPaint);
    canvas.drawPath(trackBarPath, trackBarPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

/// Range selector for custom reports. This class handles selecting
/// the custom start and end date for the report and then building
/// the report page for those dates.
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

/// Object model for handling the start and end dates for a custom report.
class DateForm extends StatefulWidget {

  /// Standard constructor for the date form model.
  DateForm({Key key, this.startDate, this.endDate}) : super(key: key);

  /// The start date for the form.
  final DateTime startDate;

  /// The end date for the form.
  final DateTime endDate;

  @override
  _DateFormState createState() => _DateFormState();
}

class _DateFormState extends State<DateForm> {

  /// Key for addressing the state.
  final _formKey = GlobalKey<FormState>();

  /// Formatter for the date to display on the form.
  static final dateFormat = DateFormat("EEEE, MMMM d, yyyy");

  /// Controller for handling updates to the start date field.
  final TextEditingController _startController = TextEditingController();

  /// Controller for handling updates to the end date field.
  final TextEditingController _endController = TextEditingController();

  /// The selected start date.
  DateTime _sDate;

  /// The selected end date.
  DateTime _eDate;

  @override
  void initState() {
    super.initState();

    _sDate = widget.startDate ?? DateTime.now();
    _eDate = widget.endDate ?? DateTime.now();

    _startController.text = dateFormat.format(_sDate);
    _endController.text = dateFormat.format(_eDate);
  }

  /// Function for the user selecting a start date.
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

  /// Function for the user selecting an end date.
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