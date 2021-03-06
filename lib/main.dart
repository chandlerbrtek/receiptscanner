import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:receipt/edit_receipt.dart';
import 'package:receipt/scan_receipt.dart';
import 'package:receipt/manual_receipt.dart';


import 'package:receipt/data/db.dart';
import 'package:receipt/data/models.dart';

import 'package:receipt/pages/budget_pages.dart';
import 'package:receipt/pages/report_pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      // home: MyHomePage(title: 'Receipt Scanner'),
      routes: {
        '/': (context) => MyHomePage(title: 'Receipt Scanner'),
        '/parsePreview': (context) => ParsePreview(),
        '/manualEntry': (context) => ManualEntryPage(),
        Budgets.ROUTE: (context) => Budgets(),
        '/reports/recent': (context) => Report_pages(state: "recent", start: 0, end: 0),
        '/reports/month': (context) => Report_pages(state: "month", start: 0, end: 0),
        '/reports/year' : (context) => Report_pages(state: "year", start: 0, end: 0),
        '/reports/custom' : (context) => DateRangeSelection(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Receipt>> _receipts;

  @override
  void initState() {
    super.initState();
    _receipts = _fetch();
    print(_receipts);
  }

  /// Retrieves the receipts within the database.
  Future<List<Receipt>> _fetch() {
    return databaseAPI.getAllReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _receiptList(),
      drawer: _drawer(),
      floatingActionButton: _addButton(),
    );
  }

  /// Builds & returns the application's navigation drawer.
  Drawer _drawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _reports(),
          ListTile(
            title: Text("Budgets"),
            trailing: Icon(Icons.assessment),
            onTap: () => Budgets.view(context),
          )
        ],
      ),
    );
  }
  /// Builds the reports section of the navigation drawer.
  ExpansionTile _reports() {
    return ExpansionTile(
      title: Text("Reports"),
      children: <Widget>[
        ListTile(
            title: Text("Recent Receipts"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => Navigator.of(context).popAndPushNamed('/reports/recent'),
        ),
        ListTile(
            title: Text("This Month"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => Navigator.of(context).popAndPushNamed('/reports/month'),
        ),
        ListTile(
            title: Text("This Year"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => Navigator.of(context).popAndPushNamed('/reports/year'),
        ),
        ListTile(
            title: Text("Custom Range"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => Navigator.of(context).popAndPushNamed('/reports/custom')
          ),
      ],
    );
  }

  /// Builds the receipt list for the home page.
  FutureBuilder<List<Receipt>> _receiptList() {
    return FutureBuilder<List<Receipt>>(
      future: _fetch(),
      builder: (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
        if (snapshot.hasData) {
          final length = snapshot.data.length;
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              final Receipt item = snapshot.data[index];

              final DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(item.receiptDate);
              final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
              final formatCurrency = new NumberFormat.simpleCurrency();

                return
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new EditEntryPage(receipt: item))
                    ),
                  child:
                    Card(
                      child: Container(
                        height: 55,
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  '${item.id}: ${formatCurrency.format(item.total / 100)} - ${dateFormat.format(date)}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ),
                  );
              
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  /// Builds the add new receipt button for the home page.
  FloatingActionButton _addButton() {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => ImagePickerModal(),
      ),
      child: Icon(Icons.add),
    );
  }
}
