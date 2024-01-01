import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/collections/collection.dart';

class CollectionsModel extends ChangeNotifier {
  final List<Collection> _items = [];

  UnmodifiableListView<Collection> get items => UnmodifiableListView(_items);

  final Set<int> selected = {};

  void add(Collection item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    //notifyListeners();
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
