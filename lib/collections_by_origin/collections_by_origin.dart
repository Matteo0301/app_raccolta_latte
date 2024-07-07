import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/collections_by_origin/collections_table.dart';
import 'package:app_raccolta_latte/model.dart';
import 'package:app_raccolta_latte/drawer.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionsByOrigin extends StatefulWidget {
  const CollectionsByOrigin(
      {super.key,
      required this.title,
      required this.username,
      required this.admin});
  final String title;
  final String username;
  final bool admin;

  @override
  State<StatefulWidget> createState() => CollectionsByOriginState();
}

class CollectionsByOriginState extends State<CollectionsByOrigin> {
  DateTime date = DateTime.now()
      .copyWith(month: DateTime.now().month + 1, day: 0, hour: 12);

  String origin = 'Tutti';
  String utente = 'Tutti';
  int total = 0;

  void setOrigin(value, redraw) {
    if (redraw) {
      setState(() {
        origin = value;
      });
    } else {
      origin = value;
    }
  }

  void setUser(value) {
    setState(() {
      utente = value;
    });
  }

  Future<List<Collection>> getCollectionList() async {
    DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
    DateTime start = end.copyWith(day: 0, hour: 12);
    String endDate = end.toIso8601String();
    String startDate = start.toIso8601String();
    final res =
        await getCollections(widget.username, widget.admin, startDate, endDate);
    return res;
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
          Column(children : [CollectionsTable(date: date, request: getCollectionList)]),
        ],
      );
      drawer = null;
      leading = false;
    } else {
      content = CollectionsTable(
          date: date, request: getCollectionList);
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
          drawer: drawer),
    );
  }
}
