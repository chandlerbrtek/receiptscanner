import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget{

  final String pageText;

  FirstPage(this.pageText);

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title: new Text(pageText)),
      body: new Center(
        child: new Text(pageText),
      )
    );
  }
}

class SecondPage extends StatelessWidget{

  final String pageText;

  SecondPage(this.pageText);

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title: new Text(pageText)),
      body: new Center(
        child: new Text(pageText),
      )
    );
  }
}

class ThirdPage extends StatelessWidget{

  final String pageText;

  ThirdPage(this.pageText);

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title: new Text(pageText)),
      body: new Center(
        child: new Text(pageText),
      )
    );
  }
}