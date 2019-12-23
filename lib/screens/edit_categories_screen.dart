import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/edit_category_item.dart';
import '../providers/categories.dart';

class EditCategoriesScreen extends StatelessWidget {
  static const routeName = '/edit_categories_screen';

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Categories'),
      ),
      body: Consumer<Categories>(
        builder: (ctx, cat, _) {
          return ListView.builder(
            itemCount: cat.getCategories.length,
            itemBuilder: (ctx, index) => EditCategoryItem(
                cat.getCategories[index].id,
                ValueKey(cat.getCategories[index].id)),
          );
        },
      ),
    );
  }
}
