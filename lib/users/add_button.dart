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
  static Future<void> inputPopup(
      BuildContext context, Model<User> users, User? initial) async {
    String? res = await showDialog(
        context: context,
        builder: (_) {
          return UserForm(
            initial: initial,
          );
        });
    if (res == null) {
      return;
    }
    final User u = User.fromJson(jsonDecode(res));

    if (initial == null) {
      await addUser(
        u,
        u.password!,
      ).then((value) => users.notifyListeners()).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
        users.notifyListeners();
      });
    } else {
      await updateUser(
        initial.name,
        u,
        u.password!,
      )
          .then((value) => {users.clearSelected(), users.notifyListeners()})
          .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
        users.notifyListeners();
      });
    }
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

class UserForm extends StatefulWidget {
  const UserForm({super.key, this.initial});
  final User? initial;

  @override
  State<StatefulWidget> createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? nameController;
  TextEditingController? passwordController;

  bool checkboxValue = false;

  void toggleCheckbox(bool value) {
    setState(() {
      checkboxValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (nameController == null || passwordController == null) {
      nameController = TextEditingController(text: widget.initial?.name);
      passwordController = TextEditingController();
      checkboxValue =
          (widget.initial != null) ? widget.initial!.isAdmin : false;
    }
    return AddDialog(
        formKey: _formKey,
        addAction: () {
          Navigator.pop(
              context,
              User(nameController!.text, checkboxValue,
                      password: passwordController!.text)
                  .toJson());
        },
        context: context,
        children: [
          TextField(
              text: 'Nome',
              error: 'Inserisci il nuovo utente',
              controller: nameController!),
          TextField(
              text: 'Password',
              error: 'Inserisci la password',
              controller: passwordController!),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: AdminCheckbox(
                onChanged: toggleCheckbox,
                initialCheckBoxValue: checkboxValue,
              )),
        ]);
  }
}
