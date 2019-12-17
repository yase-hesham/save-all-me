import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CategoryItem {
  final String id;
  final String title;
   String imageUrl;
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

  var uuid = Uuid();

  Map<String,dynamic> toJson()=>
    {
      'id':uuid.v4(),
      'title':title,
      'imageUrl':imageUrl,
      'description':description,
    };
}
