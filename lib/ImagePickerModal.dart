import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImagePickerModal extends StatelessWidget {
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

  Future _parseImage(File img) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(img);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String text = visionText.text;
    return text;
  }

  Future _takePhoto() async {
    print('take picture');
    return _getImage(ImageSource.camera);
  }

  Future _selectPhoto() async {
    print('select picture');
    return _getImage(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    ListTile _createTile(String name, IconData icon, [Function pickImage]) {
      return ListTile(
        leading: Icon(icon),
        title: Text(name),
        onTap: () async {
          var total;

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

            List<String> prices = [];
            RegExp exp = new RegExp(r"\d+\.\d{2}[^\S]");
            Iterable<Match> matches = exp.allMatches(text);
            for (Match m in matches) {
              String match = m.group(0).trim();
              prices.add(match);
            }

            //price found
            if (prices.length != 0) {
              //PROBLEMS:
              // Some scans confuse periods for commas or insert random spaces
              // Also had some '$' signs confused for a 9
              // This could be due to certain fonts or different font sizes

              int parseInt(String str) {
                return int.parse(str.replaceAll('.', ''));
              }

              prices.sort((a, b) => parseInt(a) - parseInt(b));
              print('Prices found (asc):');
              print(prices);

              //TODO: include a preview of parsed results?
              // Navigator.popAndPushNamed(context, '/parsePreview',
              //     arguments: ParsePreviewArguments(prices.toString(), text));

              total = prices.last;
            }
          }

          Navigator.popAndPushNamed(context, '/manualEntry',
              arguments: ManualEntryArgs(total));
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

class ManualEntryArgs {
  final String total;

  ManualEntryArgs(this.total);
}

class ParsePreviewArguments {
  final String prices;
  final String text;

  ParsePreviewArguments(this.prices, this.text);
}

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

class PaddedCard extends StatelessWidget {
  const PaddedCard({
    Key key,
    @required this.text,
    this.alignment,
  }) : super(key: key);

  final String text;
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
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
