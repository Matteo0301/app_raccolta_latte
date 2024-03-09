import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/origins/origins_model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddButton extends StatelessWidget {
  AddButton({super.key});
  final _formKey = GlobalKey<FormState>();

  Future<Origin?> inputPopup(BuildContext context) async {
    String? res = await showDialog(
        context: context,
        builder: (_) {
          var nameController = TextEditingController();
          var addressController = TextEditingController();
          return AlertDialog(
            title: const Text('Inserisci'),
            content: Container(
                padding: const EdgeInsets.all(10),
                height: 300,
                width: 300,
                child: ListView(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: nameController,
                                validator: (value) => value!.isEmpty
                                    ? 'Inserisci il nuovo conferente'
                                    : null,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nome'),
                              )),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: addressController,
                                validator: (value) => value!.isEmpty
                                    ? 'Inserisci l\'indirizzo'
                                    : null,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Via Roma 1, Pegognaga',
                                    labelText: 'Indirizzo'),
                              ))
                        ]))
                  ],
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annulla'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context,
                        '${nameController.text};${addressController.text}}');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inserisci un valore')));
                  }
                },
                child: const Text('Aggiungi'),
              ),
            ],
          );
        });
    debugPrint('res: $res');
    final tmp = res?.split(';');
    if (tmp == null) {
      return null;
    }
    final coordinates = await address2Coordinates(tmp[1]);
    debugPrint('$coordinates');
    if (res == null) {
      return null;
    }
    return Origin(tmp[0], coordinates.item1, coordinates.item2);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OriginsModel>(
      builder: (context, collections, child) {
        return FloatingActionButton.extended(
          onPressed: () async {
            Origin? res = await inputPopup(context);
            debugPrint('res2: $res');
            if (res != null) {
              await addOrigin(res)
                  .then((value) =>
                      {collections.add(res), collections.notifyListeners()})
                  .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString())),
                );
                collections.notifyListeners();
                return <dynamic>{};
              });
            }
            debugPrint('lista: ${collections.items}');
          },
          label: const Text('Aggiungi'),
          icon: const Icon(Icons.add),
        );
      },
    );
  }
}
