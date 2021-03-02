import 'package:flutter/material.dart';


class Category {
  final String title;
  final String dueDate;
  final IconData starred;

  const Category({
    this.title,
    this.dueDate,
    this.starred
  });
}