import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category(this.name, this.icon);
}

final List<Category> categories = [
  Category('Work', Icons.work),
  Category('Personal', Icons.person),
  Category('Shopping', Icons.shopping_cart),
  Category('Health', Icons.favorite),
  Category('Other', Icons.help),
];
