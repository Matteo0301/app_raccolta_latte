class Collection {
  final String user;
  final String origin;
  final int quantity;
  final String date;
  final int quantity2;

  Collection(this.user, this.origin, this.quantity, this.quantity2, this.date);

  @override
  String toString() {
    return 'Collection{user: $user,  quantity: $quantity, quantity2: $quantity2}';
  }

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(json['user'], json['origin'], json['quantity'],
        json['quantity2'], json['date']);
  }

  String toJson() {
    return '{"username": "$user", "origin": "$origin", "quantity": "$quantity", "quantity2": "$quantity2", "date": "$date"}';
  }
}
