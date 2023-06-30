import 'package:app_raccolta_latte/collections_model.dart';
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
                reverse: true,
                itemCount: collections.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${collections.items[collections.items.length - index - 1]}'),
                  );
                })
            /*Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${collections.items.length}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              
            ],
          ),*/
            );
      },
    );
  }
}
