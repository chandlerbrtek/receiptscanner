import 'package:flutter/material.dart';
import 'package:receipt/ImagePickerModal.dart';
import './pages/other_pages.dart';

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
            ListTile(
              title: Text("First Menu Item"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage("First Page")))
            ),
            ListTile(
              title: Text("Another Menu Item"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage("Second Page")))
            ),
            ListTile(
              title: Text("Another Menu Item"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new OtherPage("Third Page")))
            ),
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
