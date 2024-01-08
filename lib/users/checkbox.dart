import 'package:flutter/material.dart';

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
