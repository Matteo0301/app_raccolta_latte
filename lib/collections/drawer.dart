import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/theme.dart';

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
          leading: const Icon(
            Icons.home,
          ),
          title: const Text('Page 1'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.train,
          ),
          title: const Text('Page 2'),
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
          applicationName: 'My Cool App',
          applicationVersion: '1.0.25',
          applicationLegalese: '© 2019 Company',
          aboutBoxChildren: [],
          child: Text('About app'),
        ),
      ],
    );
  }
}
