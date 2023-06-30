import 'package:app_raccolta_latte/collections_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  Future<int?> inputPopup(BuildContext context) async {
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
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Quantità'),
                    )
                  ],
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annulla'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, quantityController.text);
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
    return int.parse(res);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionsModel>(
      builder: (context, collections, child) {
        return FloatingActionButton.extended(
          onPressed: () async {
            int? res = await inputPopup(context);
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
