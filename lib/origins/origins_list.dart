import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/origins/origins_model.dart';
import 'package:app_raccolta_latte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OriginsList extends StatelessWidget {
  const OriginsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OriginsModel>(
      builder: (context, origins, child) {
        return FutureBuilder(
            future: getOrigins(),
            builder: (context, snapshot) {
              print('FutureBuilder');
              if (snapshot.hasError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('${snapshot.error}')));
                return const Center(child: Text('Nessun conferente trovato'));
              } else if (snapshot.hasData) {
                List<Origin> list = snapshot.data as List<Origin>;
                origins.removeAll();
                for (var user in list) {
                  origins.add(user);
                }
                if (list.isEmpty) {
                  return const Center(child: Text('Nessun conferente trovato'));
                }
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
                              origins.toggleSelected(
                                  origins.items.length - index - 1);
                            },
                          );
                        }));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
    );
  }
}
