import 'dart:collection';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:flutter/material.dart';

class UsersModel extends ChangeNotifier {
  final List<User> _items = [User('User1', false)];
  final Set<int> _selected = {};

  UnmodifiableListView<User> get items => UnmodifiableListView(_items);
  UnmodifiableSetView<int> get selected => UnmodifiableSetView(_selected);

  void add(User item) {
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
    if (!_selected.contains(index)) {
      _selected.add(index);
    } else {
      _selected.remove(index);
    }
    print(_selected);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
