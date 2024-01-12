import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:flutter/material.dart';

class UsersDropdown extends StatelessWidget {
  const UsersDropdown(this.onChanged,
      {super.key, this.includeSelectAll = false});
  final ValueSetter<String> onChanged;
  final bool includeSelectAll;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Utente: '),
      ),
      FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Nessun utente trovato'));
          } else if (snapshot.hasData) {
            List<User> list = snapshot.data as List<User>;
            return UsersDropdownHelper(list, onChanged, includeSelectAll);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    ]);
  }
}

class UsersDropdownHelper extends StatefulWidget {
  const UsersDropdownHelper(this.users, this.onChanged, this.includeSelectAll,
      {super.key});
  final List<User> users;
  final ValueSetter<String> onChanged;
  final bool includeSelectAll;

  @override
  State<StatefulWidget> createState() => DropdownState();
}

class DropdownState extends State<UsersDropdownHelper> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) return const Text('Nessun utente trovato');
    if (widget.includeSelectAll && widget.users[0].name != 'Tutti') {
      widget.users.insert(0, User('Tutti', false));
    }
    if (selected == '') selected = widget.users[0].name;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selected,
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
        ),
        onChanged: (value) {
          setState(() {
            if (value == null) {
              selected = '';
            } else {
              selected = value;
              widget.onChanged(selected);
            }
          });
        },
        items: widget.users.map<DropdownMenuItem<String>>((User value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }
}
