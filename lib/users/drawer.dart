import 'package:app_raccolta_latte/collections/home.dart';
import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/theme.dart';

import '../origins/origin_page.dart';

class AppMenu extends StatelessWidget {
  final String username;
  final bool admin;

  const AppMenu({super.key, required this.username, required this.admin});
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: MyTheme.mainColor),
          accountName: Text(
            username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          accountEmail: const Text(
            '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ),
        ListTile(
          title: const Text('Home'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Home(title: '', username: username, admin: admin);
            }));
          },
        ),
        ListTile(
          title: const Text('Conferenti'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OriginPage(title: '', username: username, admin: admin);
            }));
          },
        ),
        ListTile(
          title: const Text('Utenti'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout_rounded,
          ),
          title: const Text('Logout'),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        const AboutListTile(
          icon: Icon(
            Icons.info,
          ),
          applicationIcon: Icon(
            Icons.local_play,
          ),
          applicationName: 'App Raccolta Latte',
          applicationVersion: '1.0.0',
          aboutBoxChildren: [],
          child: Text('About app'),
        ),
      ],
    );
  }
}
