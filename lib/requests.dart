import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000';

class User {
  final String username;
  final bool admin;

  const User({required this.username, required this.admin});

  factory User.fromJson(Map<String, dynamic> json, String username) {
    return User(username: username, admin: json['admin']);
  }
}

Future<User?> login_request(username, password) async {
  final response =
      await http.get(Uri.parse('$baseUrl/users/auth/$username/$password'));
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body), username);
  } else {
    return null;
  }
}
