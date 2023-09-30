import 'dart:convert';
import 'dart:io';
import 'package:app_raccolta_latte/users/user.dart';

import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000';
String token = '';

class LoggedUser {
  final String username;
  final bool admin;

  const LoggedUser({required this.username, required this.admin});

  factory LoggedUser.fromJson(Map<String, dynamic> json, String username) {
    token = json['token'];
    return LoggedUser(username: username, admin: json['admin']);
  }
}

void logout() {
  token = '';
}

Future<LoggedUser> login_request(username, password) async {
  try {
    final response =
        await http.get(Uri.parse('$baseUrl/users/auth/$username/$password'));
    if (response.statusCode == 200) {
      return LoggedUser.fromJson(jsonDecode(response.body), username);
    } else {
      return Future.error("Credenziali errate");
    }
  } catch (e) {
    return Future.error("Impossibile connettersi al server");
  }
}

Future<List<User>> getUsers() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/users'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List<User> users = [];
      for (var user in jsonDecode(response.body)['users']) {
        users.add(User.fromJson(user));
      }
      return users;
    } else {
      return Future.error("Operazione non permessa");
    }
  } catch (e) {
    return Future.error(e.toString());
  }
}
