import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/category_item.dart';

class Categories with ChangeNotifier {
  List<Category> categories = [
    Category(id: 'id1', title: 'Books', items: [
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
    ])
  ];

  List<Category> get getCategories {
    return [...categories];
  }

  List<CategoryItem>  categoryItems(String id){
    return findCategoryById(id).items;
  }

  Category findCategoryById(String id) {
    return categories.firstWhere((cat) => cat.id == id);
  }

  CategoryItem findCategoryItemById(String id, String categoryId) {
    return findCategoryById(categoryId)
        .items
        .firstWhere((item) => item.id == id);
  }

  void addCategory(String title) {
    categories.add(Category(
        id: DateTime.now().toIso8601String(), title: title, items: []));
    notifyListeners();
  }

  void addItemToCategory(String catId, CategoryItem item) {
    findCategoryById(catId).items.add(item);
    notifyListeners();
  }

  List<CategoryItem> findItemsByCatIdAndTitle(String catId,String title){
    Category cat = findCategoryById(catId);

    return cat.items.where((item)=>item.title.toLowerCase().contains(title.toLowerCase())).toList();
  }

  void deleteCategory(String id){
    categories.removeWhere((cat)=>cat.id==id);
    notifyListeners();
  }

  void updateCategoryTitle(String id,String title){
    findCategoryById(id).title=title;
  }
}
