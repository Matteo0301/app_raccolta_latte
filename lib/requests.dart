import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://localhost:3000';
final String domain = dotenv.env['DOMAIN'] ?? 'dummy.com';
final String? key = dotenv.env['MAPS_KEY'];
String token = '';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = _certificateCheck;
  }
}

bool _certificateCheck(cert, host, port) {
  return host == domain || host == 'localhost';
}

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

Future<LoggedUser> loginRequest(username, password) async {
  try {
    final response = await runZonedGuarded<Future<http.Response?>>(() async {
      try {
        return await http
            .get(Uri.parse('$baseUrl/users/auth/$username/$password'))
            .timeout(const Duration(seconds: 1));
      } catch (e) {
        return null;
      }
    }, (error, stack) {
      print('Impossibile connettersi al server');
    });
    if (response == null) {
      return Future.error('Impossibile connettersi al server');
    }
    if (response.statusCode == 200) {
      return LoggedUser.fromJson(jsonDecode(response.body), username);
    } else {
      return Future.error('Credenziali errate');
    }
  } catch (e) {
    return Future.error(e);
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
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> removeUsers(List<User> users) async {
  try {
    for (var u in users) {
      print('$baseUrl/users/${u.name}');
      final response = await http.delete(Uri.parse('$baseUrl/users/${u.name}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode != 204) {
        return Future.error('Operazione non permessa');
      }
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> addUser(User user, String pass) async {
  try {
    final response = await http.put(Uri.parse('$baseUrl/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'username': user.name,
          'admin': user.isAdmin.toString(),
          'password': pass
        }));
    print('Response: ${response.body}');
    if (response.statusCode != 201) {
      print('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    print('Error: $e');
    return Future.error('Impossibile connettersi al server');
  }
}

Future<List<Origin>> getOrigins() async {
  try {
    debugPrint(Uri.encodeFull('$baseUrl/origins'));
    final response = await http.get(Uri.parse('$baseUrl/origins'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      List<Origin> origins = [];
      for (var user in jsonDecode(response.body)) {
        origins.add(Origin.fromJson(user));
      }
      return origins;
    } else {
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> removeOrigins(List<Origin> origins) async {
  try {
    for (var o in origins) {
      print('$baseUrl/origins/${o.name}');
      final response = await http.delete(
          Uri.parse('$baseUrl/origins/${o.name}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode != 201) {
        return Future.error('Operazione non permessa');
      }
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> addOrigin(Origin origin) async {
  try {
    final response = await http.post(
        Uri.parse(
            '$baseUrl/origins/${origin.name}/${origin.lat}/${origin.lng}'),
        headers: {'Authorization': 'Bearer $token'});
    print('Response: ${response.body}');
    if (response.statusCode != 201) {
      print('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    print('Error: $e');
    return Future.error('Impossibile connettersi al server');
  }
}

Future<List<Collection>> getCollections(
    String username, bool admin, String startDate, String endDate) async {
  final String url;
  if (admin) {
    url = '$baseUrl/collections/$startDate/$endDate';
  } else {
    url = '$baseUrl/collections/byuser/$username/$startDate/$endDate';
  }
  try {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(response.body);
    if (response.statusCode == 200) {
      List<Collection> collections = [];
      for (var user in jsonDecode(response.body)) {
        collections.add(Collection.fromJson(user));
      }
      print(collections.toString());
      return collections;
    } else {
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> addCollection(Collection collection, bool admin) async {
  final Map<String, String> body = <String, String>{
    'quantity': collection.quantity.toString(),
    'quantity2': collection.quantity2.toString(),
    'date': collection.date.toIso8601String()
  };
  try {
    final response = await http.post(
        Uri.parse(
            '$baseUrl/collections/${collection.user}/${collection.origin}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));
    print('Response: ${response.body}');
    if (response.statusCode != 201) {
      print('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    print('Error: $e');
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> removeCollections(List<Collection> collections) async {
  try {
    for (var c in collections) {
      final response = await http.delete(
          Uri.parse('$baseUrl/collections/${c.id}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 204) {
        return Future.error('Operazione non permessa');
      }
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<Tuple2<double, double>> address2Coordinates(String address) async {
  final String url =
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(address)}&key=${key}';
  try {
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      if (res['status'] == 'OK') {
        var lat = res['results'][0]['geometry']['location']['lat'];
        var lng = res['results'][0]['geometry']['location']['lng'];
        return Tuple2(lat, lng);
      } else {
        return Future.error('Indirizzo non trovato');
      }
    } else {
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi');
  }
}
