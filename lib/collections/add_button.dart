import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/collections/collections_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddButton extends StatelessWidget {
  AddButton({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  Future<Collection?> inputPopup(BuildContext context) async {
    String? res = await showDialog(
        context: context,
        builder: (_) {
          var quantityController = TextEditingController();
          return AlertDialog(
            title: const Text('Inserisci'),
            content: Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                child: ListView(
                  children: [
                    Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'Inserisci la quantità' : null,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Quantità'),
                        ))
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
                    Navigator.pop(context, quantityController.text);
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
    debugPrint('res1: $res');
    if (res == null) {
      return null;
    }
    final quantity = double.parse(res);
    return Collection('user', 'origin', quantity,
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute}');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionsModel>(
      builder: (context, collections, child) {
        return FloatingActionButton.extended(
          onPressed: () async {
            Collection? res = await inputPopup(context);
            debugPrint('res2: $res');
            if (res != null) {
              collections.add(res);
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
