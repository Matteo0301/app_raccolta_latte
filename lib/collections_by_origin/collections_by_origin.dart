import 'package:app_raccolta_latte/drawer.dart';
import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/origins/origins_list.dart';
import 'package:app_raccolta_latte/origins/origins_model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionsByOrigin extends StatelessWidget {
  const CollectionsByOrigin(
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
              current: 'Raccolte per conferente',
            ),
          ),
          const Expanded(flex: 3, child: OriginsList()),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = const OriginsList();
      drawer = Drawer(
          child: AppMenu(
        username: username,
        admin: admin,
        current: 'Raccolte per conferente',
      ));
    }

    return ChangeNotifierProvider(
      create: (context) => OriginsModel(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Consumer<OriginsModel>(
                builder: (context, origins, child) {
                  if (origins.selected.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return IconButton(
                        onPressed: () async {
                          List<Origin> o = [];
                          for (var index in origins.selected) {
                            o.add(origins.items[index]);
                          }
                          removeOrigins(o)
                              .then((value) => {origins.notifyListeners()})
                              .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                            origins.notifyListeners();
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
      ),
    );
  }
}
