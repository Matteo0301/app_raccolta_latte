import 'package:app_raccolta_latte/collections/collections_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionsList extends StatelessWidget {
  const CollectionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionsModel>(
      builder: (context, collections, child) {
        return Center(
            child: ListView.builder(
                itemCount: collections.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        style: const TextStyle(fontSize: 20),
                        'Conferente: ${collections.items[collections.items.length - index - 1].origin}'),
                    subtitle: Text(
                        'Quantità: ${collections.items[collections.items.length - index - 1].quantity}'),
                    trailing: Text(
                        '${collections.items[collections.items.length - index - 1].user}   (${collections.items[collections.items.length - index - 1].date})'),
                    selected: collections.selected
                        .contains(collections.items.length - index - 1),
                    selectedTileColor: Colors.blue[100],
                    onTap: () {
                      collections
                          .toggleSelected(collections.items.length - index - 1);
                    },
                  );
                }));
      },
    );
  }
}
