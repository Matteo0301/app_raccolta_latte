import 'package:app_raccolta_latte/model.dart';
import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/utils.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  static Future<void> inputPopup(
      BuildContext context, Model<Origin> origins, Origin? initial) async {
    String? s = await showDialog(
        context: context,
        builder: (_) => OriginForm(
              initial: initial,
            ));
    final tmp = s?.split(';');
    if (tmp == null) {
      return;
    }
    final coordinates = await address2Coordinates(tmp[1]).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
      return const Tuple2(0.0, 0.0);
    });
    if (coordinates == const Tuple2(0.0, 0.0)) {
      return;
    }
    if (s == null) {
      return;
    }
    final o = Origin(tmp[0], coordinates.item1, coordinates.item2);
    if (initial == null) {
      await addOrigin(o)
          .then((value) => {origins.add(o), origins.notifyListeners()})
          .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
        origins.notifyListeners();
        return <dynamic>{};
      });
    } else {
      await updateOrigin(initial.name, o)
          .then((value) => {origins.clearSelected(), origins.notifyListeners()})
          .onError((error, stackTrace) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString())),
                ),
                origins.notifyListeners()
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Model<Origin>>(
      builder: (context, origins, child) {
        return Button<Origin>(inputPopup: inputPopup, model: origins);
      },
    );
  }
}

class OriginForm extends StatelessWidget {
  OriginForm({super.key, required this.initial});
  final _formKey = GlobalKey<FormState>();
  final Origin? initial;

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(text: initial?.name);
    var addressController = TextEditingController();
    return AddDialog(
        formKey: _formKey,
        addAction: () {
          Navigator.pop(
              context, '${nameController.text};${addressController.text}}');
        },
        context: context,
        children: [
          TextField(
              text: 'Nome',
              error: 'Inserisci il nuovo conferente',
              controller: nameController),
          TextField(
              text: 'Indirizzo',
              error: 'Inserisci l\'indirizzo',
              hint: 'Via Roma 1, Pegognaga',
              controller: addressController),
        ]);
  }
}
