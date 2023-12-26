class Collection {
  final String user;
  final String origin;
  final double quantity;
  final String date;
  final double quantity2;

  Collection(this.user, this.origin, this.quantity, this.quantity2, this.date);

  @override
  String toString() {
    return 'Collection{user: $user,  quantity: $quantity, quantity2: $quantity2}';
  }
}
