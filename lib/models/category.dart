
import 'package:flutter/material.dart';

import '../models/category_item.dart';

class Category{
  final String id;
  String title;
  final List<CategoryItem> items;

  Category({@required this.id,@required this.title,@required this.items});
}