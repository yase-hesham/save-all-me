import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CategoryItem {
   String id;
   String title;
   String imageUrl;
   String description;

  CategoryItem({
    @required this.id,
    @required this.title,
    this.imageUrl,
    @required this.description,
  });

  set setId(id){
    this.id=id;
  }  
  CategoryItem.fromMap(Map<dynamic,dynamic> data):
    id=data['id']??'',
    title=data['title']??'',
    imageUrl=data['imageUrl']??'',
    description=data['description']??'';

  var uuid = Uuid();

  Map<String,dynamic> toJson()=>
    {
      'id':id==null?uuid.v4():id,
      'title':title,
      'imageUrl':imageUrl,
      'description':description,
    };
}
