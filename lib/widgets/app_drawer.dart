import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_all_me/providers/auth_service.dart';

import '../screens/category_screen.dart';
import '../screens/edit_categories_screen.dart';
import '../models/category.dart';
import '../providers/categories.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Categories>(context).getCategories;
    return Drawer(
      elevation: 8,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: DrawerHeader(
              child: Text('Save all me'),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              
            ),
          ),
           ListTile(
            leading: const Icon(Icons.edit),
            title:const  Text('Edit Categories'),
            onTap: () {
              Navigator.pushNamed(context, EditCategoriesScreen.routeName);
            },
          ),
          ExpansionTile(
            title: const Text('Categories'),
            leading:const  Icon(Icons.category),
            children:
                categories.map((item) => DrawerCategoryItem(item)).toList(),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log out'),
              onTap: () {
                Navigator.pop(context);
                Provider.of<AuthService>(context,listen: false).logout();

              },
            ),
          )
        ],
      ),
    );
  }
}

class DrawerCategoryItem extends StatelessWidget {
  final Category cat;
  DrawerCategoryItem(this.cat);

  Widget _buildItemTiles(Category root,BuildContext context) {
    return  ListTile(
      key: PageStorageKey<Category>(root),
      title: Text(
        root.title,
        style: TextStyle(fontSize: 12),
      ),
      contentPadding: EdgeInsets.only(left: 30),
      leading: Icon(Icons.arrow_right),
      onTap: (){
        Navigator.pop(context);
        Navigator.pushNamed(context, CategoryScreen.routeName,arguments: cat.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemTiles(cat,context);
  }
}
