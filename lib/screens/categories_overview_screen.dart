import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/categories_items_list.dart';
import '../widgets/app_drawer.dart';
import '../providers/categories.dart';

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
    
    return Scaffold(
      appBar: AppBar(
title: Text('Welcome'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showAddCategoryDialog(context),
              )
            ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('/categories/${widget.currentUser.uid}/cats/').snapshots(),
        builder: (ctx,snapshot){
          if(!snapshot.hasData) return Center(child:Text('No Data'));
          else return CategoriesItemsWidget(snapshot,widget.currentUser.uid);
        },
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
                  .addCategory(_titleController.text,widget.currentUser.uid);
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
    showDialog(context: context, builder: (ctx) => addCategoryDialog);
  }
}
