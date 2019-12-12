import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../models/category.dart';
import '../providers/categories.dart';
import '../widgets/category_widget.dart';

class CategoriesOverviewScreen extends StatefulWidget {
  final FirebaseUser currentUser;

  CategoriesOverviewScreen(this.currentUser);
  @override
  _CategoriesOverviewScreenState createState() =>
      _CategoriesOverviewScreenState();
}

class _CategoriesOverviewScreenState extends State<CategoriesOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Category> catData =
        Provider.of<Categories>(context, listen: false).getCategories;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Welcome'),
            floating: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showAddCategoryDialog(context),
              )
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top:8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  (ctx, index) => CategoryWidget(
                        categoryId: catData[index].id,
                      ),
                  childCount: catData.length),
                  
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final _titleController = TextEditingController();
    bool _hasInputError = false;
    AlertDialog addCategoryDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      title: Text('Add Category'),
      content: Container(
        margin: EdgeInsets.all(8),
        child: TextField(
          onChanged: (value) {
            _hasInputError = value.length < 4;
            setState(() {});
          },
          controller: _titleController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category Title',
              errorText: _hasInputError ? 'Value can\'t be empty' : null),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Add Catalog'),
          onPressed: () {
            if (!_hasInputError && _titleController.text.isNotEmpty) {
              Provider.of<Categories>(context)
                  .addCategory(_titleController.text);
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
    showDialog(context: context, builder: (ctx) => addCategoryDialog);
  }
}
