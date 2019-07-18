import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt/ManualEntry.dart';

/// The modal for entering a new receipt in the application. This
/// modal appears on the bottom of the screen and provides three
/// options for adding a new receipt:
/// 
/// - Take Photo
/// 
/// - Use Photo
/// 
/// - Enter Manually
class ImagePickerModal extends StatelessWidget {

  /// Class scope identifier for the application build context.
  BuildContext manual;

  /// The implementing logic for retrieving an image either from
  /// the device's camera or its file system.
  Future _getImage(ImageSource src) async {
    final File image = await ImagePicker.pickImage(source: src);

    if (image != null)
      print('Image received...');
    else
      print('No image selected...');
  }

  /// The take new photo option. This method implements the logic for
  /// taking a new photo of a receipt.
  void _takePhoto() {
    print('take picture');
    _getImage(ImageSource.camera);
  }

  /// The use existing photo option. This method implements the logic
  /// for using a photo existing on the device's file system.
  void _selectPhoto() {
    print('select picture');
    _getImage(ImageSource.gallery);
  }

  /// The enter receipt manually option. This method implements the
  /// logic for building a displaying the manual entryh page.
  void _manualEntry() {
    ManualEntryPage manualEntryPage = new ManualEntryPage();
    Navigator.push(manual, MaterialPageRoute(builder: (manual) => manualEntryPage.entryPage(manual)));
  }

  @override
  Widget build(BuildContext context) {
    manual = context;
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
