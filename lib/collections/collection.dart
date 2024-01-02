class Collection {
  final String user;
  final String origin;
  final int quantity;
  final DateTime date;
  final int quantity2;
  final String id;

  Collection(this.id, this.user, this.origin, this.quantity, this.quantity2,
      this.date);

  @override
  String toString() {
    return 'Collection{id: $id, user: $user,  quantity: $quantity, quantity2: $quantity2}';
  }

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(json['_id'], json['user'], json['origin'],
        json['quantity'], json['quantity2'], DateTime.parse(json['date']));
  }

  String toJson() {
    return '{"id": "$id", "username": "$user", "origin": "$origin", "quantity": "$quantity", "quantity2": "$quantity2", "date": "$date"}';
  }
}
