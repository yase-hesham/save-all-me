import 'dart:io';
import 'package:path/path.dart' as path; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/category_item.dart';


class Categories with ChangeNotifier {
  final databaseReference = Firestore.instance;
  String userId;
  List<Category> categories = [
    /*Category(id: 'id1', title: 'Books', items: [
      CategoryItem(
        id: 'book1',
        title: 'Book1',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://i.imgur.com/is54KC9.jpg',
      ),
      CategoryItem(
        id: 'book2',
        title: 'Book1',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://i.imgur.com/TlIJ8vd.jpg',
      ),
      CategoryItem(
        id: 'book3',
        title: 'Book2',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://i.imgur.com/4bHPPK5.jpg',
      )
    ]),
    Category(id: 'id2', title: 'Anime', items: [
      CategoryItem(
        id: 'Anime1',
        title: 'Book1',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://i.imgur.com/T4L7Iou.jpg',
      ),
      CategoryItem(
        id: 'Anime2',
        title: 'anime2',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://i.imgur.com/K81jGw5.jpg',
      )
    ]),
    Category(id: 'id3', title: 'Books2', items: [
      CategoryItem(
        id: 'book4',
        title: 'Book1',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://www.netclipart.com/pp/m/13-136636_book-transparent-png-image-clipart-free-download-books.png',
      ),
      CategoryItem(
        id: 'book5',
        title: 'Book2',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://www.netclipart.com/pp/m/22-226056_book-clipart-png-clip-art-stack-of-books.png',
      )
    ]),
    Category(id: 'id4', title: 'Books2', items: [
      CategoryItem(
        id: 'book6',
        title: 'Book1',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://www.netclipart.com/pp/m/13-136636_book-transparent-png-image-clipart-free-download-books.png',
      ),
      CategoryItem(
        id: 'book7',
        title: 'Book2',
        description: 'it\'s a book no.1',
        imageUrl:
            'https://www.netclipart.com/pp/m/22-226056_book-clipart-png-clip-art-stack-of-books.png',
      )
    ])*/
  ];

  Categories({this.userId});

  List<Category> get getCategories {
    return [...categories];
  }

  Future<String> uploadFile(File image) async{
    StorageReference storageReference = FirebaseStorage.instance.ref().child('pictures/$userId/${path.basename(image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final fileUrl= await storageReference.getDownloadURL();
    return fileUrl;
  }

  Future<void> fetchAndSetCategories() async {}

  void getData(AsyncSnapshot<QuerySnapshot> snapshot, String userId) {
    this.userId = userId;
    categories = snapshot.data.documents.map((doc) {
      return Category(
        id: doc.documentID,
        items: [
          ...(doc.data['items']).map((items) {
            return CategoryItem.fromMap(items);
          })
        ], 
        title: doc.data['title'],
      );
    }).toList();
  }

  List<CategoryItem> categoryItems(String id) {
    return findCategoryById(id).items;
  }

  Category findCategoryById(String id) {
    return categories.firstWhere((cat) => cat.id == id);
  }

  CategoryItem findCategoryItemById(String itemId, String categoryId) {
    return findCategoryById(categoryId)
        .items
        .firstWhere((item) => item.id == itemId);
  }



  Future<void> addCategory(String title, String userId) async {
    await databaseReference
        .collection('/categories/$userId/cats')
        .add({'title': title, 'items': []});

    notifyListeners();
  }

  Future<void> addItemToCategory(String catId, CategoryItem item,File image) async{
    final imageUrl = await uploadFile(image);
    
    print(imageUrl);
    item.imageUrl=imageUrl;
    Category cat = findCategoryById(catId);
    cat.items.add(item);
    print(cat.items.length);

    await databaseReference
        .collection('categories/$userId/cats')
        .document('$catId')
        .updateData({
      'items': [
        ...cat.items.map((item) {
          return item.toJson();
        })
      ]
    });

    notifyListeners();
  }

  List<CategoryItem> findItemsByCatIdAndTitle(String catId, String title) {
    Category cat = findCategoryById(catId);

    return cat.items
        .where((item) => item.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  Future<void> deleteCategory(String id,)async {
    Category cat = findCategoryById(id);
    await databaseReference
        .collection('categories/$userId/cats')
        .document('${cat.id}').delete();
    categories.removeWhere((cat) => cat.id == id);
    notifyListeners();
  }

  Future<void> updateCategoryTitle(String id, String title) async {
    Category cat = findCategoryById(id);
    await databaseReference
        .collection('categories/$userId/cats')
        .document('${cat.id}')
        .updateData({'title': title});

      cat.title = title;

    findCategoryById(id).title = title;
      print(cat.title);
      print(findCategoryById(id).title);
      notifyListeners();
      

  }

}
