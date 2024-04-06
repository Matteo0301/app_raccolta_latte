import 'package:app_raccolta_latte/collections/add_button.dart';
import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
//import 'package:app_raccolta_latte/collections/drawer.dart';
import 'package:app_raccolta_latte/collections/collections_list.dart';
import 'package:provider/provider.dart';

import '../drawer.dart';

class Home extends StatelessWidget {
  const Home(
      {super.key,
      required this.title,
      required this.username,
      required this.admin});
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

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      required this.username,
      required this.admin});

  final String title;
  final String username;
  final bool admin;

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DateTime date = DateTime.now()
      .copyWith(month: DateTime.now().month + 1, day: 0, hour: 12);

  Future<List<Collection>> getCollectionList() async {
    DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
    DateTime start = end.copyWith(day: 0, hour: 12);
    String endDate = end.toIso8601String();
    String startDate = start.toIso8601String();
    return await getCollections(
        widget.username, widget.admin, startDate, endDate);
  }

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
              username: widget.username,
              admin: widget.admin,
              current: 'Home',
            ),
          ),
          Expanded(
              flex: 3,
              child: CollectionsList(
                  widget.username, widget.admin, date, getCollectionList)),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = CollectionsList(
          widget.username, widget.admin, date, getCollectionList);
      drawer = Drawer(
          child: AppMenu(
        username: widget.username,
        admin: widget.admin,
        current: 'Home',
      ));
    }
    return ChangeNotifierProvider(
      create: (context) => Model<Collection>(),
      child: Scaffold(
          appBar: AppBar(
              title: Text(
                  'Mese: ${date.month.toString().padLeft(2, "0")}/${date.year}'),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                Consumer<Model<Collection>>(
                  builder: (context, collections, child) {
                    if (collections.selected.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      return IconButton(
                          onPressed: () {
                            List<Collection> coll = [];
                            for (var index in collections.selected) {
                              coll.add(collections.items[index]);
                            }
                            removeCollections(coll)
                                .then(
                                    (value) => {collections.notifyListeners()})
                                .catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                              collections.notifyListeners();
                              return <dynamic>{};
                            });
                          },
                          icon: const Icon(Icons.delete));
                    }
                  },
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        date = date.copyWith(
                            month: date.month + 2, day: 0, hour: 12);
                        if (date.isAfter(DateTime.now())) {
                          date = DateTime.now().copyWith(
                              month: DateTime.now().month + 1,
                              day: 0,
                              hour: 12);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        date = date.copyWith(day: 0, hour: 12);
                        if (date.isBefore(DateTime(2021, 1, 1))) {
                          date = DateTime(2021, 1, 1);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
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
          floatingActionButton:
              AddButton(username: widget.username, admin: widget.admin),
          drawer: drawer),
    );
  }
}
