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
}
