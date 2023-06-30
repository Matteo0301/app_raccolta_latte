import 'package:app_raccolta_latte/add_button.dart';
import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/drawer.dart';
import 'package:app_raccolta_latte/collections_list.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app_raccolta_latte/collections_model.dart';

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

class HomePage extends StatefulWidget {
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*void inputPopup() {
    showDialog(
        context: context,
        builder: (_) {
          var quantityController = TextEditingController();
          return AlertDialog(
            title: const Text('Inserisci'),
            content: Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                width: 100,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Quantità'),
                    )
                  ],
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annulla'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, quantityController.text);
                },
                child: const Text('Aggiungi'),
              ),
            ],
          );
        }).then((value) => {
          if (value != null)
            {
              setState(() {
                _counter += int.parse(value);
              })
            }
        });
  }*/

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
        username: widget.username,
        admin: widget.admin,
      ));
    }
    return ChangeNotifierProvider(
      create: (context) => CollectionsModel(),
      child: Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
              automaticallyImplyLeading: false,
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
          floatingActionButton: const AddButton(),
          drawer: drawer),
    );
  }
}
