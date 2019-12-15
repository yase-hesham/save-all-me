import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_all_me/widgets/category_widget.dart';

import '../providers/categories.dart';

class CategoriesItemsWidget extends StatelessWidget {
  final snapshot;
  CategoriesItemsWidget(this.snapshot);

  @override
  Widget build(BuildContext context) {
    Provider.of<Categories>(context,listen: false).getData(snapshot);
    final catData = Provider.of<Categories>(context).getCategories;
    return ListView.builder(
      itemBuilder: (ctx,index)=>CategoryWidget(categoryId: catData[index].id,),
      itemCount: catData.length
    );
  }
}