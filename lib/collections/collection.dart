class Collection {
  final String user;
  final String origin;
  final double quantity;
  final String date;

  Collection(this.user, this.origin, this.quantity, this.date);

  @override
  String toString() {
    return 'Collection{user: $user,  quantity: $quantity}';
  }
}
