import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_raccolta_latte/collections/collection.dart';
import 'package:app_raccolta_latte/origins/origin.dart';
import 'package:app_raccolta_latte/users/user.dart';
import 'package:app_raccolta_latte/secrets.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

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
        return await http.get(
            Uri.https(baseUrl, '/users/auth/$username/$password'),
            headers: {
              'Access-Control-Allow-Origin':
                  '*', // Required for CORS support to work
              'Access-Control-Allow-Credentials':
                  'true', // Required for cookies, authorization headers with HTTPS
              'Access-Control-Allow-Headers':
                  'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
              'Access-Control-Allow-Methods': 'POST, OPTIONS'
            });
      } catch (e) {
        return null;
      }
    }, (error, stack) {
      debugPrint('Impossibile connettersi al server');
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
    final response = await http.get(Uri.https(baseUrl, '/users'),
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
      debugPrint('$baseUrl/users/${u.name}');
      final response = await http.delete(Uri.https(baseUrl, '/users/${u.name}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode != 204) {
        return Future.error('Operazione non permessa');
      }
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> updateUser(String name, User user, String pass) async {
  try {
    debugPrint('$baseUrl/users/$name');
    final response = await http.patch(Uri.https(baseUrl, '/users/$name'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(<String, String>{
          'username': user.name,
          'admin': user.isAdmin.toString(),
          'password': pass
        }));
    if (response.statusCode != 204) {
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> addUser(User user, String pass) async {
  try {
    final response = await http.put(Uri.https(baseUrl, '/users'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(<String, String>{
          'username': user.name,
          'admin': user.isAdmin.toString(),
          'password': pass
        }));
    debugPrint('Response: ${response.body}');
    if (response.statusCode != 201) {
      debugPrint('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    debugPrint('Error: $e');
    return Future.error('Impossibile connettersi al server');
  }
}

Future<List<Origin>> getOrigins() async {
  try {
    debugPrint(Uri.encodeFull('$baseUrl/origins'));
    final response = await http.get(Uri.https(baseUrl, '/origins'),
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
      debugPrint('$baseUrl/origins/${o.name}');
      final response = await http.delete(
          Uri.https(baseUrl, '/origins/${o.name}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode != 201) {
        return Future.error('Operazione non permessa');
      }
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> updateOrigin(String name, Origin origin) async {
  try {
    debugPrint('$baseUrl/origins/$name');
    final response = await http.patch(Uri.https(baseUrl, '/origins/$name'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(<String, String>{
          'name': origin.name,
          'lat': '${origin.lat}',
          'lng': '${origin.lng}',
        }));
    if (response.statusCode != 204) {
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> addOrigin(Origin origin) async {
  try {
    final response = await http.post(
        Uri.https(
            baseUrl, '/origins/${origin.name}/${origin.lat}/${origin.lng}'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    debugPrint('Response: ${response.body}');
    if (response.statusCode != 201) {
      debugPrint('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    debugPrint('Error: $e');
    return Future.error('Impossibile connettersi al server');
  }
}

Future<List<Collection>> getCollections(
    String username, bool admin, String startDate, String endDate) async {
  final String url;
  if (admin) {
    url = 'collections/$startDate/$endDate';
  } else {
    url = 'collections/byuser/$username/$startDate/$endDate';
  }
  try {
    final response = await http.get(Uri.https(baseUrl, url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    debugPrint(response.body);
    if (response.statusCode == 200) {
      List<Collection> collections = [];
      for (var user in jsonDecode(response.body)) {
        collections.add(Collection.fromJson(user));
      }
      debugPrint(collections.toString());
      return collections;
    } else {
      return Future.error('Operazione non permessa');
    }
  } catch (e) {
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> addCollection(Collection collection, String? filename) async {
  String base64Image;
  if (filename == null) {
    base64Image = '';
  } else {
    List<int> imageBytes = await File(filename).readAsBytes();
    base64Image = base64Encode(imageBytes);
  }
  final Map<String, String> body = <String, String>{
    'quantity': collection.quantity.toString(),
    'quantity2': collection.quantity2.toString(),
    'date': collection.date.toIso8601String(),
    'image': base64Image
  };
  try {
    final response = await http.post(
        Uri.https(
            baseUrl, '/collections/${collection.user}/${collection.origin}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(body));
    //debugPrint('Response: ${response.body}');
    if (response.statusCode != 201) {
      debugPrint('Wrong status code');
      return Future.error('Errore durante l\'operazione');
    }
  } catch (e) {
    debugPrint('Error: $e');
    return Future.error('Impossibile connettersi al server');
  }
}

Future<void> removeCollections(List<Collection> collections) async {
  try {
    for (var c in collections) {
      final response = await http.delete(
          Uri.https(baseUrl, '/collections/${c.id}'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      debugPrint('$response.statusCode');
      debugPrint(response.body);
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
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(address)}&key=$key';
  try {
    final response = await http.get(Uri.parse(url));
    debugPrint(response.body);
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
