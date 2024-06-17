import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            // ToDo: change to image
            // child: Text('Invoice Manager', style: TextStyle(fontSize: 24)),
            child: Image.asset('assets/images/invest.jpg'),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.home,
            press: () {
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 10.0,
      leading: Icon(
        icon,
        color: Colors.black,
        applyTextScaling: true,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
