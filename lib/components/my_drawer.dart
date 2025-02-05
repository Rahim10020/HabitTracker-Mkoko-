import 'package:flutter/material.dart';
import 'package:pro3_flutter/components/my_drawer_tile.dart';
import 'package:pro3_flutter/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          // drawer header
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Icon(
              Icons.hail_outlined,
              size: 68,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          // the divider
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          // home drawer tile
          MyDrawerTile(
            text: "HOME",
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // settings drawer tile
          MyDrawerTile(
            text: "SETTINGS",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
