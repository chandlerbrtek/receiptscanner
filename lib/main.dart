import 'package:flutter/material.dart';
import 'package:receipt/ImagePickerModal.dart';
import './pages/other_pages.dart';
import './pages/first_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Receipt Scanner'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ExpansionTile(title: Text("Reports"),
            children: <Widget>[            
              ListTile(
              title: Text("Recent Receipts"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new First()))
            ),
            ListTile(
              title: Text("Month"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SecondPage("Second Page")))
            ),
            ListTile(
              title: Text("Year"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ThirdPage("Third")))
              ),
            ],
            ),
            ExpansionTile(title: Text("Budgeting"),
            children: <Widget>[            
              ListTile(
              title: Text("Placeholder"),
              trailing: Icon(Icons.arrow_forward),
              ),
            ],
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => ImagePickerModal(),
            ),
        child: Icon(Icons.add),
      ),
    );
  }
}
