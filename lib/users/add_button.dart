import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/origins/origins_model.dart';
import 'package:app_raccolta_latte/users/users_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddButtonState();
  }
}

class AddButtonState extends State<AddButton> {
  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;

  Future<User?> inputPopup(BuildContext context) async {
    checkboxValue = false;
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
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              validator: (value) => value!.isEmpty
                                  ? 'Inserisci il nuovo utente'
                                  : null,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nome'),
                            ),
                            Checkbox(
                                value: checkboxValue,
                                onChanged: (value) {
                                  
                                  setState(() {
                                    if (value == null) {
                                      checkboxValue = false;
                                    } else {
                                      checkboxValue = value;
                                    }
                                  });
                                })
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
                    Navigator.pop(context, User(nameController.text, checkboxValue));
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
    User u = res as User;
    return u;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersModel>(
      builder: (context, users, child) {
        return FloatingActionButton.extended(
          onPressed: () async {
            User? res = await inputPopup(context);
            debugPrint('res2: $res');
            if (res != null) {
              users.add(res);
            }
            debugPrint('lista: ${users.items}');
          },
          label: const Text('Aggiungi'),
          icon: const Icon(Icons.add),
        );
      },
    );
  }
}
