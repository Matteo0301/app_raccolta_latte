import 'package:html/parser.dart';

class User {
  final String name;
  bool isAdmin;
  String? password;

  User(this.name, this.isAdmin, {this.password});

  void toggleAdmin() {
    isAdmin = !isAdmin;
  }

  @override
  String toString() {
    if (password != null) {
      return 'User{name: $name, admin: $isAdmin, password: $password}';
    } else {
      return 'User{name: $name, admin: $isAdmin}';
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['password'] != null) {
      return User(parseFragment(json['username']).text!, json['admin'],
          password: json['password']);
    } else {
      return User(parseFragment(json['username']).text!, json['admin']);
    }
  }

  String toJson() {
    if (password != null) {
      return '{"username": "$name", "password": "$password", "admin": $isAdmin}';
    } else {
      return '{"username": "$name", "admin": $isAdmin}';
    }
  }
}
