import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/origins/origins_model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddButton extends StatelessWidget {
  AddButton({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  Future<Origin?> inputPopup(BuildContext context) async {
    String? res = await showDialog(
        context: context,
        builder: (_) {
          var nameController = TextEditingController();
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
                          controller: nameController,
                          validator: (value) => value!.isEmpty
                              ? 'Inserisci il nuovo conferente'
                              : null,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Nome'),
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
                    Navigator.pop(context, nameController.text);
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
    if (res == null) {
      return null;
    }
    return Origin(res);
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
              //collections.add(res);
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
