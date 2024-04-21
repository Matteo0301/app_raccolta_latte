import 'dart:io';

import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/model.dart';
import 'package:app_raccolta_latte/origins_dropdown.dart';
import 'package:app_raccolta_latte/date_time_picker.dart';
import 'package:app_raccolta_latte/recognizer.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/utils.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key, required this.username, required this.admin});
  final String username;
  final bool admin;

  @override
  State<StatefulWidget> createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  String origin = '';
  DateTime date = DateTime.now();
  late ImagePicker _picker; // = ImagePicker();

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  final _formKey = GlobalKey<FormState>();
  final MLKitTextRecognizer recognizer = MLKitTextRecognizer();

  Future<String?> obtainImage() async {
    final String? file;
    if (Platform.isAndroid || Platform.isIOS) {
      file = (await _picker.pickImage(source: ImageSource.camera))?.path;
    } else {
      file = null;
    }
    return file;
  }

  Future<void> inputPopup(BuildContext context, Model<Collection> collections,
      Collection? initial) async {
    date = DateTime.now();
    String? filePath = await obtainImage();
    debugPrint('File path: $filePath');
    final String recognized;
    if (filePath != null) {
      recognized = await recognizer.processImage(filePath);
    } else {
      recognized = '';
    }
    debugPrint(recognized);

    String? s;
    if (context.mounted) {
      s = await showDialog(
          context: context,
          builder: (_) {
            var quantityController = TextEditingController(text: recognized);
            var quantity2Controller = TextEditingController(text: '0');
            return AddDialog(
                formKey: _formKey,
                addAction: () {
                  Navigator.pop(context,
                      '${quantityController.text};${quantity2Controller.text}');
                },
                context: context,
                children: [
                  TextField(
                      text: 'Quantità',
                      error: 'Inserisci la quantità',
                      controller: quantityController),
                  TextField(
                      text: 'Seconda',
                      error: 'Inserisci il latte di seconda',
                      controller: quantity2Controller),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OriginsDropdown((value, redraw) {
                        origin = value;
                      })),
                  DateTimePicker(
                    date: date,
                    onChanged: (value) {
                      date = value;
                    },
                    admin: widget.admin,
                  ),
                ]);
          });
    }

    if (s == null) {
      return;
    }
    var tmp = s.split(';');
    final quantity = int.parse(tmp[0]);
    final quantity2 = int.parse(tmp[1]);
    debugPrint('$date');
    final Collection c =
        Collection('', widget.username, origin, quantity, quantity2, date);
    await addCollection(c)
        .then((value) => {collections.add(c), collections.notifyListeners()})
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
      collections.notifyListeners();
      return <dynamic>{};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Model<Collection>>(
      builder: (context, collections, child) {
        return Button<Collection>(inputPopup: inputPopup, model: collections);
      },
    );
  }
}
