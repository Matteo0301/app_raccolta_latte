import 'package:app_raccolta_latte/collections/add_button.dart';
import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/collections/drawer.dart';
import 'package:app_raccolta_latte/collections/collections_list.dart';
import 'package:provider/provider.dart';
import 'package:app_raccolta_latte/collections/collections_model.dart';

class Home extends StatelessWidget {
  const Home(
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
    return HomePage(
      title: title,
      admin: admin,
      username: username,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage(
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
          const Expanded(flex: 3, child: CollectionsList()),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = const CollectionsList();
      drawer = Drawer(
          child: AppMenu(
        username: username,
        admin: admin,
      ));
    }
    return ChangeNotifierProvider(
      create: (context) => CollectionsModel(),
      child: Scaffold(
          appBar: AppBar(
              title: Text(title),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                Consumer<CollectionsModel>(
                  builder: (context, collections, child) {
                    return IconButton(
                        onPressed: () {
                          collections.removeSelected();
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
          floatingActionButton: AddButton(username),
          drawer: drawer),
    );
  }
}
