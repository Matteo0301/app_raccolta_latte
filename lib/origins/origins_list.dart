import 'package:app_raccolta_latte/origins/origins_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OriginsList extends StatelessWidget {
  const OriginsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OriginsModel>(
      builder: (context, origins, child) {
        return Center(
            child: ListView.builder(
                itemCount: origins.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        style: const TextStyle(fontSize: 20),
                        'Conferente: ${origins.items[origins.items.length - index - 1].name}'),
                    selected: origins.selected
                        .contains(origins.items.length - index - 1),
                    selectedTileColor: Colors.blue[100],
                    onTap: () {
                      origins.toggleSelected(origins.items.length - index - 1);
                    },
                  );
                }));
      },
    );
  }
}
