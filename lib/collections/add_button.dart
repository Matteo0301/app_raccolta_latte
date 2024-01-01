import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/collections/collections_model.dart';
import 'package:app_raccolta_latte/collections/origins_dropdown.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddButton extends StatelessWidget {
  AddButton(this.username, {Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final String username;
  String origin = '';

  Future<Collection?> inputPopup(BuildContext context) async {
    String? res = await showDialog(
        context: context,
        builder: (_) {
          var quantityController = TextEditingController();
          var quantity2Controller = TextEditingController(text: '0');
          return AlertDialog(
            title: const Text('Inserisci'),
            content: Container(
                padding: const EdgeInsets.all(10),
                height: 300,
                width: 100,
                child: ListView(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.isEmpty
                                      ? 'Inserisci la quantità'
                                      : null,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Quantità'),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: quantity2Controller,
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.isEmpty
                                      ? 'Inserisci il latte di seconda'
                                      : null,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Seconda'),
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OriginsDropdown((value) {
                                  origin = value;
                                }))
                          ],
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
                    Navigator.pop(context,
                        '${quantityController.text};${quantity2Controller.text}');
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
    print(origin);
    if (res == null) {
      return null;
    }
    var tmp = res.split(';');
    final quantity = int.parse(tmp[0]);
    final quantity2 = int.parse(tmp[1]);
    return Collection('', username, origin, quantity, quantity2,
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
              await addCollection(
                res,
              )
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
