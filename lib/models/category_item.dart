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

  CategoryItem.fromMap(Map<dynamic,dynamic> data):
    id=data['id']??'',
    title=data['title']??'',
    imageUrl=data['imageUrl']??'',
    description=data['description']??'';
}
