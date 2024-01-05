import 'package:app_raccolta_latte/collections/add_button.dart';
import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/requests.dart';
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
          Expanded(flex: 3, child: CollectionsList(username, admin)),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = CollectionsList(username, admin);
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
                          //collections.removeSelected();
                          List<Collection> coll = [];
                          for (var index in collections.selected) {
                            coll.add(collections.items[index]);
                          }
                          removeCollections(coll)
                              .then((value) => {collections.notifyListeners()})
                              .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                            collections.notifyListeners();
                            return <dynamic>{};
                          });
                        },
                        icon: const Icon(Icons.delete));
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
          floatingActionButton: AddButton(username: username, admin: admin),
          drawer: drawer),
    );
  }
}
