import 'dart:math';
import 'package:html/parser.dart';

class Origin {
  final String name;
  final double lat;
  final double lng;

  Origin(this.name, this.lat, this.lng);

  @override
  String toString() {
    return 'Origin{name: $name}';
  }

  String toJson() {
    return '{"name": "$name", "lat": $lat, "lng": $lng}';
  }

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(parseFragment(json['name']).text!, json['lat'], json['lng']);
  }

  distance(location) {
    return sqrt(
        pow(location.latitude - lat, 2) + pow(location.longitude - lng, 2));
  }
}
