import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:receipt/data/db.dart';
import 'package:receipt/data/models.dart';
import 'package:receipt/main.dart';

class Report_pages extends StatelessWidget {
  final double _smallFontSize = 12;
  final double _valFontSize = 30;
  final FontWeight _smallFontWeight = FontWeight.w500;
  final FontWeight _valFontWeight = FontWeight.w700;
  final Color _fontColor = Color(0xff5b6990);
  final double _smallFontSpacing = 1.3;
  static final DateTime _dateTime = DateTime.now();
  static final List<int> finalDayOfMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  final int _beginYear = DateTime(_dateTime.year, 1, 1, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
  final int _endYear = DateTime(_dateTime.year + 1, 1, 1, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
  final int _beginMonth = DateTime(_dateTime.year, _dateTime.month, 1, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
  final int _endMonth = DateTime(_dateTime.year, _dateTime.month, finalDayOfMonth[_dateTime.month - 1], 0, 0, 0, 0, 0).millisecondsSinceEpoch;
  final headerStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff5b6990));

  final String state;
  final int customStart;
  final int customEnd;

  Report_pages(this.state, this.customStart, this.customEnd);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: new Container(
        decoration: new BoxDecoration(color: Colors.white),
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
                      color: Color(0xfff0f5fb),
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

class ReceiptsInRange extends StatelessWidget {
  const ReceiptsInRange({
    Key key,
    int start,
    int end
  }) : _start = start,
        _end = end,
        super(key: key);

  final int _start;
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

///Legacy code
///
class RecordItem extends StatelessWidget {
  const RecordItem({
    Key key,
    @required Color fontColor,
    @required double smallFontSpacing,
    @required this.day,
  })  : _fontColor = fontColor,
        _smallFontSpacing = smallFontSpacing,
        super(key: key);

  final Color _fontColor;
  final double _smallFontSpacing;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xffdde9f7),
        width: 1.5,
      ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            day,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: _fontColor),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text(
                "01/21/2019",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: _smallFontSpacing,
                    color: _fontColor),
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Text(
                  "45.3 MINUTES",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: _smallFontSpacing,
                      color: _fontColor),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _Receipt extends StatelessWidget {
  final Receipt receipt;
  final textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.3,
      color: Color(0xff5b6990));
  final dateFormat = DateFormat("MM/dd/yyyy");
  final formatCurrency = new NumberFormat.simpleCurrency();

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
