import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerModal extends StatelessWidget {
  Future _getImage(ImageSource src) async {
    final File image = await ImagePicker.pickImage(source: src);

    if (image != null)
      print('Image received...');
    else
      print('No image selected...');
  }

  void _takePhoto() {
    print('take picture');
    _getImage(ImageSource.camera);
  }

  void _selectPhoto() {
    print('select picture');
    _getImage(ImageSource.gallery);
  }

  void _manualEntry() {
    print('manual entry???');
  }

  @override
  Widget build(BuildContext context) {
    ListTile _createTile(String name, IconData icon, Function action) {
      return ListTile(
          leading: Icon(icon),
          title: Text(name),
          onTap: () {
            Navigator.pop(context);
            action();
          });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _createTile('Take a photo', Icons.camera, _takePhoto),
        _createTile('Select a photo', Icons.photo, _selectPhoto),
        _createTile('Enter manually', Icons.keyboard, _manualEntry)
      ],
    );
  }
}
