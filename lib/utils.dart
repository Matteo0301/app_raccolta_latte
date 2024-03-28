import 'package:app_raccolta_latte/model.dart';
import 'package:flutter/material.dart';

class AddDialog extends AlertDialog {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback addAction;
  final BuildContext context;

  AddDialog(
      {super.key,
      required this.formKey,
      required this.children,
      required this.addAction,
      required this.context})
      : super(
          title: const Text('Inserisci'),
          content: Container(
              padding: const EdgeInsets.all(10),
              height: 300,
              width: 300,
              child: ListView(
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        children: children,
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
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  addAction();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inserisci un valore')));
                }
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
}

class TextField extends StatelessWidget {
  final String text;
  final String error;
  final TextEditingController controller;
  final String hint;

  const TextField(
      {super.key,
      required this.text,
      required this.error,
      required this.controller,
      this.hint = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? error : null,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: text,
            hintText: hint),
      ),
    );
  }
}

class AdminCheckbox extends StatefulWidget {
  final void Function(bool) onChanged;

  const AdminCheckbox({super.key, required this.onChanged});

  @override
  AdminCheckboxState createState() => AdminCheckboxState();
}

class AdminCheckboxState extends State<AdminCheckbox> {
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checkboxValue,
          onChanged: (value) {
            setState(() {
              checkboxValue = value!;
            });
            widget.onChanged(checkboxValue);
          },
        ),
        const Text('Amministratore')
      ],
    );
  }
}

class Button<T> extends StatelessWidget {
  final Future<void> Function(BuildContext context, Model<T> initial)
      inputPopup;
  final Model<T> model;

  const Button({super.key, required this.inputPopup, required this.model});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async => inputPopup(context, model),
      label: const Text('Aggiungi'),
      icon: const Icon(Icons.add),
    );
  }
}
