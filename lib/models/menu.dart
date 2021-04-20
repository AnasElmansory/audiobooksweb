import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu {
  final String title;
  final IconData icon;

  const Menu({
    this.title,
    this.icon,
  });
}

const List<Menu> menuItems = [
  const Menu(title: 'Books', icon: FontAwesomeIcons.book),
  const Menu(title: 'Reviews', icon: Icons.reviews),
  const Menu(title: 'Users', icon: Icons.person),
  const Menu(title: 'Push Notifications', icon: Icons.notification_important),
];
