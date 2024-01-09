import 'package:app_raccolta_latte/collections/home.dart';
import 'package:app_raccolta_latte/collections_by_origin/collections_by_origin.dart';
import 'package:app_raccolta_latte/origins/origin_page.dart';
import 'package:flutter/material.dart';
import 'package:app_raccolta_latte/theme.dart';
import '../users/users_page.dart';

class AppMenu extends StatelessWidget {
  final String username;
  final bool admin;
  final String current;

  const AppMenu(
      {super.key,
      required this.username,
      required this.admin,
      required this.current});
  @override
  Widget build(BuildContext context) {
    final Widget origins;
    final Widget users;
    final Widget collectionsByOrigin;
    const empty = SizedBox.shrink();

    final children = [
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
        ),
      ),
      ListTile(
        title: const Text('Home'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Home(title: 'Raccolte', username: username, admin: admin);
          }));
        },
      )
    ];

    if (admin) {
      origins = ListTile(
        title: const Text('Conferenti'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OriginPage(
                title: 'Conferenti', username: username, admin: admin);
          }));
        },
      );
      users = ListTile(
        title: const Text('Utenti'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UsersPage(title: 'Utenti', username: username, admin: admin);
          }));
        },
      );
      collectionsByOrigin = ListTile(
        title: const Text('Raccolte per conferente'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CollectionsByOrigin(
                title: 'Raccolte per conferente',
                username: username,
                admin: admin);
          }));
        },
      );
    } else {
      origins = empty;
      users = empty;
      collectionsByOrigin = empty;
    }

    children.add(origins);
    children.add(users);
    children.add(collectionsByOrigin);

    for (var child in children) {
      if (child.runtimeType == ListTile &&
          (child as ListTile).title.runtimeType == Text) {
        if (((child).title as Text).data != null &&
            ((child).title as Text).data == current) {
          child = ListTile(
            title: Text(((child).title as Text).data!),
            onTap: () {
              Navigator.pop(context);
            },
          );
        }
      }
    }

    children.addAll([
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
    ]);

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: children,
    );
  }
}
