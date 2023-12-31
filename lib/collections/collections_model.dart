import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/collections/collection.dart';

class CollectionsModel extends ChangeNotifier {
  final List<Collection> _items = [
    Collection('user1', 'origin', 1, 0,
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute}'),
    Collection('user2', 'origin', 2, 1,
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute}'),
    Collection('user3', 'origin', 3, 1,
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute}'),
    Collection('user4', 'origin', 4, 3,
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute}'),
    Collection('user5', 'origin', 5, 1,
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute}'),
  ];

  UnmodifiableListView<Collection> get items => UnmodifiableListView(_items);

  final Set<int> selected = {};

  void add(Collection item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    //notifyListeners();
  }

  void toggleSelected(int index) {
    if (!selected.contains(index)) {
      selected.add(index);
    } else {
      selected.remove(index);
    }
    print(selected);
    notifyListeners();
  }

  void removeSelected() {
    final List<int> l = selected.toList();
    l.sort();
    for (int i in l.reversed) {
      print(i);
      _items.removeAt(i);
    }
    print(_items);
    selected.clear();
    notifyListeners();
  }
}
