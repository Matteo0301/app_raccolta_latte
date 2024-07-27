import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/collections/home.dart';
import 'package:app_raccolta_latte/requests.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});
  final String title;

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    autofillHints: const [AutofillHints.username],
                    controller: userController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci il nome utente';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    autofillHints: const [AutofillHints.password],
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password'),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci la password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // request to the server
                          String username = userController.text;
                          String password = passwordController.text;

                          loginRequest(username, password).then(
                            (user) async {
                              log('user: $user');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          title: widget.title,
                                          username: user.username,
                                          admin: user.admin,
                                        )),
                              );
                            },
                          ).onError(
                            (error, stackTrace) async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Non hai inserito i dati correttamente')),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Login', style: TextStyle(fontSize: 20)),
                      ),
                      /* const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Login', style: TextStyle(fontSize: 20)),
                    ), */
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
