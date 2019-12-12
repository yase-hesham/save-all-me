import 'package:flutter/foundation.dart';

class CategoryItem {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  CategoryItem({
    @required this.id,
    @required this.title,
    this.imageUrl,
    @required this.description,
  });
}
