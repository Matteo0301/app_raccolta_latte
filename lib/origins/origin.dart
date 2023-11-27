class Origin {
  final String name;

  Origin(this.name);

  @override
  String toString() {
    return 'Origin{name: $name}';
  }

  String toJson() {
    return '{"name": "$name"}';
  }

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(json['name']);
  }
}
