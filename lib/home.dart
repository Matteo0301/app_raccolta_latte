import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/drawer.dart';
import 'package:app_raccolta_latte/collections_list.dart';
import 'package:flutter/services.dart';

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
  int _counter = 0;

  void inputPopup() {
    showDialog(
        context: context,
        builder: (_) {
          var quantityController = TextEditingController();
          return AlertDialog(
            title: Text('Inserisci'),
            content: TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Quantità'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annulla'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, quantityController.text);
                },
                child: Text('Aggiungi'),
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
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    Drawer? drawer;
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
          Expanded(
              flex: 3,
              child: CollectionsList(
                counter: _counter,
              )),
        ],
      );
      drawer = null;
    } else {
      content = CollectionsList(
        counter: _counter,
      );
      drawer = Drawer(
          child: AppMenu(
        username: widget.username,
        admin: widget.admin,
      ));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: content,
        floatingActionButton: FloatingActionButton(
          onPressed: inputPopup,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        drawer: drawer);
  }
}
