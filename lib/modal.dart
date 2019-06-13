import 'package:flutter/material.dart';

class Modal {
  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Scan new receipt', Icons.receipt, _action1()),
              _createTile(context, 'Select a photo', Icons.camera, _action2()),
              _createTile(context, 'Enter manually', Icons.keyboard, _action3())
            ],
          );
        }
    );
  }

  ListTile _createTile(BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        //action(); will be used once we have the pages set up to navigate to
      }
    );
  }

  _action1() {
    //navigate to scan new receipt page
  }

  _action2() {
    //navigate to select photo page
  }

  _action3() {
    //navigate to manual entry page
  }
}