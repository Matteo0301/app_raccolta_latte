class User {
  final String name;
  bool isAdmin;

  User(this.name, this.isAdmin);

  void toggleAdmin() {
    isAdmin = !isAdmin;
  }

  @override
  String toString() {
    return 'User{name: $name, admin: $isAdmin}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['username'], json['admin']);
  }
}
