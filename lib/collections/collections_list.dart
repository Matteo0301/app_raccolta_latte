import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/collections/collections_model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionsList extends StatelessWidget {
  const CollectionsList(this.username, this.admin, this.date, {super.key});
  final String username;
  final bool admin;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    DateTime start = date.subtract(const Duration(days: 30));
    String endDate = date.toIso8601String();
    String startDate = start.toIso8601String();
    return Consumer<CollectionsModel>(
      builder: (context, collections, child) {
        return FutureBuilder(
          future: getCollections(username, admin, startDate, endDate),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Nessun dato trovato'));
            } else if (snapshot.hasData) {
              List<Collection> list = snapshot.data as List<Collection>;
              collections.removeAll();
              for (var coll in list) {
                collections.add(coll);
              }
              if (list.isEmpty) {
                return const Center(child: Text('Nessun dato trovato'));
              }
              return Center(
                  child: ListView.builder(
                      itemCount: collections.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              style: const TextStyle(fontSize: 20),
                              'Conferente: ${collections.items[collections.items.length - index - 1].origin}'),
                          subtitle: Text(
                              'Quantità: ${collections.items[collections.items.length - index - 1].quantity}, Seconda: ${collections.items[collections.items.length - index - 1].quantity2}'),
                          trailing: Text(
                              '${collections.items[collections.items.length - index - 1].user}   (${collections.items[collections.items.length - index - 1].date.day.toString().padLeft(2, '0')}/${collections.items[collections.items.length - index - 1].date.month.toString().padLeft(2, '0')}/${collections.items[collections.items.length - index - 1].date.year} ${collections.items[collections.items.length - index - 1].date.hour}:${collections.items[collections.items.length - index - 1].date.minute.toString().padLeft(2, '0')})'),
                          selected: collections.selected
                              .contains(collections.items.length - index - 1),
                          selectedTileColor: Colors.blue[100],
                          onTap: () {
                            collections.toggleSelected(
                                collections.items.length - index - 1);
                          },
                        );
                      }));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
