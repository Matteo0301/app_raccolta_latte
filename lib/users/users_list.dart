import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:app_raccolta_latte/users/users_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersModel>(builder: (context, users, child) {
      return FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('${snapshot.error}')));
              return const Center(child: Text('Nessun utente trovato'));
            } else if (snapshot.hasData) {
              List<User> list = snapshot.data as List<User>;
              users.removeAll();
              for (var user in list) {
                users.add(user);
              }
              if (list.isEmpty) {
                return const Center(child: Text('Nessun utente trovato'));
              }
              return Center(
                  child: ListView.builder(
                      itemCount: users.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              style: const TextStyle(fontSize: 20),
                              'Utente: ${users.items[users.items.length - index - 1].name}'),
                          subtitle: users
                                  .items[users.items.length - index - 1].isAdmin
                              ? const Text('Amministratore')
                              : const Text(''),
                          selected: users.selected
                              .contains(users.items.length - index - 1),
                          selectedTileColor: Colors.blue[100],
                          onTap: () {
                            users
                                .toggleSelected(users.items.length - index - 1);
                          },
                        );
                      }));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    });
  }
}
