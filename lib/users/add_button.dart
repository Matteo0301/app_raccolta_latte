import 'dart:convert';
import 'package:app_raccolta_latte/model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:app_raccolta_latte/utils.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:provider/provider.dart';

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

  Future<void> inputPopup(BuildContext context, Model<User> users) async {
    checkboxValue = false;
    String? res = await showDialog(
        context: context,
        builder: (_) {
          var nameController = TextEditingController();
          var passwordController = TextEditingController();
          return AddDialog(
              formKey: _formKey,
              addAction: () {
                Navigator.pop(
                    context,
                    User(nameController.text, checkboxValue,
                            password: passwordController.text)
                        .toJson());
              },
              context: context,
              children: [
                TextField(
                    text: 'Nome',
                    error: 'Inserisci il nuovo utente',
                    controller: nameController),
                TextField(
                    text: 'Password',
                    error: 'Inserisci la password',
                    controller: passwordController),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: AdminCheckbox(onChanged: toggleCheckbox)),
              ]);
        });
    if (res == null) {
      return;
    }
    final User u = User.fromJson(jsonDecode(res));

    await addUser(
      u,
      u.password!,
    )
        .then((value) =>
            {u.password = null, users.add(u), users.notifyListeners()})
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
      users.notifyListeners();
      return <dynamic>{};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Model<User>>(
      builder: (context, users, child) {
        return Button<User>(inputPopup: inputPopup, model: users);
      },
    );
  }
}
