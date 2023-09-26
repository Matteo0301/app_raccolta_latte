import 'dart:collection';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:flutter/material.dart';

class UsersModel extends ChangeNotifier {
  final List<User> _items = [User('User1', false)];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<User> get items => UnmodifiableListView(_items);

  final Set<int> selected = {};

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => _items.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(User item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
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

  void toggleAdmin(int index) {
    _items[index].toggleAdmin();
    notifyListeners();
  }
}
