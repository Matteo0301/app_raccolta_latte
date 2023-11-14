import 'package:app_raccolta_latte/requests.dart';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:app_raccolta_latte/users/users_list.dart';
import 'package:app_raccolta_latte/users/users_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_button.dart';
import 'drawer.dart';

class UsersPage extends StatelessWidget {
  const UsersPage(
      {Key? key,
      required this.title,
      required this.username,
      required this.admin})
      : super(key: key);
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
      ));
    }

    return ChangeNotifierProvider(
      create: (context) => UsersModel(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Consumer<UsersModel>(
                builder: (context, u, child) {
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
                },
              ),
              // TODO this is here only to resolve a bug, should be removed when ready
              IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
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
