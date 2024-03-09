import 'dart:convert';

import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/users/checkbox.dart';
import 'package:app_raccolta_latte/users/users_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddButtonState();
  }
}

class AddButtonState extends State<AddButton> {
  final _formKey = GlobalKey<FormState>();

  bool checkboxValue = false;

  void toggleCheckbox(bool value) {
    setState(() {
      checkboxValue = value;
    });
  }

  Future<User?> inputPopup(BuildContext context) async {
    checkboxValue = false;
    String? res = await showDialog(
        context: context,
        builder: (_) {
          var nameController = TextEditingController();
          var passwordController = TextEditingController();
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: nameController,
                                validator: (value) => value!.isEmpty
                                    ? 'Inserisci il nuovo utente'
                                    : null,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nome'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) => value!.isEmpty
                                    ? 'Inserisci la password'
                                    : null,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password'),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child:
                                    AdminCheckbox(onChanged: toggleCheckbox)),
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
                    Navigator.pop(
                        context,
                        User(nameController.text, checkboxValue,
                                password: passwordController.text)
                            .toJson());
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
    User u = User.fromJson(jsonDecode(res));
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
              await addUser(
                res,
                res.password!,
              )
                  .then((value) => {
                        res.password = null,
                        users.add(res),
                        users.notifyListeners()
                      })
                  .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString())),
                );
                users.notifyListeners();
                return <dynamic>{};
              });
              //users.add(res);
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
