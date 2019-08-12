import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

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

  /// Date Formats for the image picker.
  static final dateFormats = [DateFormat("M/d/y"), DateFormat("MMM d y")];

  /// The implementing logic for retrieving an image either from
  /// the device's camera or its file system.
  Future _getImage(ImageSource src) async {
    final File image = await ImagePicker.pickImage(source: src);

    if (image != null) {
      print('Image received...');
      return image;
    } else {
      print('No image selected...');
      return null;
    }
  }

  /// Function for parsing an image. Takes image selected by the user and scans
  /// it using Firebase Vision.
  Future _parseImage(File img) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(img);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String text = visionText.text;
    return text;
  }

  /// The take new photo option. This method implements the logic for
  /// taking a new photo of a receipt.
  Future _takePhoto() async {
    print('take picture');
    return _getImage(ImageSource.camera);
  }

  /// The use existing photo option. This method implements the logic
  /// for using a photo existing on the device's file system.
  Future _selectPhoto() async {
    print('select picture');
    return _getImage(ImageSource.gallery);
  }

  Widget build(BuildContext context) {
    ListTile _createTile(String name, IconData icon, [Function pickImage]) {
      return ListTile(
        leading: Icon(icon),
        title: Text(name),
        onTap: () async {
          ManualEntryArgs args = ManualEntryArgs();

          // img entry
          if (pickImage != null) {
            final img = await pickImage();
            if (img == null) return; //img not selected

            print('Parsing image...');
            String text = await _parseImage(img);

            //TODO: construct a better regex or implement alg for findings prices/totals
            //CURRENT REGEX:
            // Accepts a string that begins with more than one digit
            // followed by a period and two additional digits. Any
            // character before or after this string is rejected.
            // It does not accomodate for thousands separators.
            // For ex. '4',  '4.00-' and '4,000.00' are rejected

            Set<String> _prices = new Set();
            RegExp exp = RegExp(r"\b\d+\.\d{2}\b");
            Iterable<Match> matches = exp.allMatches(text);
            for (Match m in matches) {
              String match = m.group(0).trim();
              _prices.add(match);
            }

            //price found
            if (_prices.length != 0) {
              //PROBLEMS:
              // Some scans confuse periods for commas or insert random spaces
              // Also had some '$' signs confused for a 9
              // This could be due to certain fonts or different font sizes

              int parseInt(String str) {
                return int.parse(str.replaceAll('.', ''));
              }

              List<String> prices = _prices.toList();
              prices.sort((a, b) => parseInt(a) - parseInt(b));
              print('Prices found (asc):');
              print(prices);

              //preview prices found
              // Navigator.popAndPushNamed(context, '/parsePreview',
              //     arguments: ParsePreviewArguments(prices.toString(), text));

              args.setPrices(prices);
            }

            List<DateTime> dates = [];
            RegExp dateRegex = RegExp(r"\b(\d{1,2}(\/|\-)){2}(\d{4}|\d{2})\b");
            Iterable<Match> datesMatched = dateRegex.allMatches(text);
            for (Match m in datesMatched) {
              String match = m.group(0).trim().replaceAll('-', '/');
              dates.add(dateFormats[0].parse(match));
            }

            if (dates.length == 0) {
              dateRegex = RegExp(r"\b\w{3,9}\s\d{1,2}(\,?)\s(\d{4}|\d{2})\b");
              datesMatched = dateRegex.allMatches(text);
              for (Match m in datesMatched) {
                String match = m.group(0).trim().replaceAll(',', '');
                dates.add(dateFormats[1].parse(match));
              }
            }

            if (dates.length != 0) {
              //preview dates found
              // Navigator.popAndPushNamed(context, '/parsePreview',
              //     arguments: ParsePreviewArguments(dates.toString(), text));

              args.setDate(dates.first);
            }
          }

          //TODO: should each option go to the exact same page?
          Navigator.popAndPushNamed(context, '/manualEntry', arguments: args);
        },
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _createTile('Take a photo', Icons.camera, _takePhoto),
        _createTile('Select a photo', Icons.photo, _selectPhoto),
        _createTile('Enter manually', Icons.keyboard)
      ],
    );
  }
}

/// Arguments used to populate the manual entry page. These values populate
/// the manual entry page when it's invoked.
class ManualEntryArgs {
  List<String> prices;
  DateTime date;

  ManualEntryArgs()
      : this.prices = null,
        this.date = null;

  /// Setter for the prices list.
  setPrices(List<String> prices) => this.prices = prices;

  /// Setter for the date.
  setDate(DateTime date) => this.date = date;
}

/// The preview arguments for the prices.
class ParsePreviewArguments {
  
  /// The prices.
  final String prices;

  /// The text for the preview.
  final String text;

  /// Standard construtor for the arguments object.
  ParsePreviewArguments(this.prices, this.text);
}

/// Parse Preview object for viewing the parsed totals.
class ParsePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ParsePreviewArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Parse Preview'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              PaddedCard(
                text: args.prices,
                alignment: MainAxisAlignment.center,
              ),
              PaddedCard(
                text: args.text,
                alignment: MainAxisAlignment.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Padded card containing text.
class PaddedCard extends StatelessWidget {

  /// Constructor for setting the card's text and alignment.
  const PaddedCard({
    Key key,
    @required this.text,
    this.alignment,
  }) : super(key: key);

  /// The text to hold within the padded card.
  final String text;

  /// The alignment of the card.
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Row(
            mainAxisAlignment: alignment,
            children: <Widget>[
              Flexible(
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
