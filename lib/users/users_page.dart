import 'package:app_raccolta_latte/drawer.dart';
import 'package:app_raccolta_latte/model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/users/add_button.dart';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:app_raccolta_latte/users/users_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage(
      {super.key,
      required this.title,
      required this.username,
      required this.admin});
  final String title;
  final String username;
  final bool admin;
  @override
  Widget build(BuildContext context) {
    Widget content;
    Drawer? drawer;
    bool leading = true;
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width > 800) {
      content = Row(
        children: [
          Expanded(
            flex: 1,
            child: AppMenu(
              username: username,
              admin: admin,
              current: 'Utenti',
            ),
          ),
          const Expanded(flex: 3, child: UsersList()),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = const UsersList();
      drawer = Drawer(
          child: AppMenu(
        username: username,
        admin: admin,
        current: 'Utenti',
      ));
    }

    return ChangeNotifierProvider(
      create: (context) => Model<User>(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Consumer<Model<User>>(
                builder: (context, u, child) {
                  if (u.selected.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return IconButton(
                        onPressed: () async {
                          List<User> users = [];
                          for (var index in u.selected) {
                            users.add(u.items[index]);
                          }
                          removeUsers(users)
                              .then((value) => {u.notifyListeners()})
                              .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                            u.notifyListeners();
                            return <dynamic>{};
                          });
                        },
                        icon: const Icon(Icons.delete));
                  }
                },
              ),
            ],
            leading: !leading
                ? null
                : Builder(builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        if (leading) {
                          Scaffold.of(context).openDrawer();
                        }
                      },
                    );
                  })),
        body: content,
        drawer: drawer,
        floatingActionButton: const AddButton(),
      ),
    );
  }
}
