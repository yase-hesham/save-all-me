import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_all_me/screens/splash_screen.dart';
import 'package:save_all_me/widgets/custom_top_bar.dart';

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
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        centerTitle: true,
//        elevation: 8,
//        title: Text('Welcome'),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () => _showAddCategoryDialog(context),
//          )
//        ],
//      ),
      drawer: AppDrawer(),
    appBar: TopBar(
      title: 'Welcome',
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add,color: Theme.of(context).primaryColor,),
          onPressed: () => _showAddCategoryDialog(context),
        ),
      ],
    ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('/categories/${widget.currentUser.uid}/cats/')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else if (!snapshot.hasData)
            return Center(
                child: Text(
              'No Categories :\'(',
              style: TextStyle(
                fontSize: 40,
                color: Theme.of(context).primaryColor,
              ),
            ));
          else
            return CategoriesItemsWidget(snapshot, widget.currentUser.uid);
        },
      ),

    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    bool _isLoading = false;
    GlobalKey<FormState> key = GlobalKey();
     final _titleController = TextEditingController();
    bool _hasInputError = false;
    AlertDialog addCategoryDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      title: Text('Add Category'),
      content: Container(
        margin: EdgeInsets.all(8),
        child: Form(
          key: key,
                  child: TextFormField(
            
            validator: (value){
              if(value.isEmpty){
                return "Invalid Title";
              }else if(value.length>10){
                return "Can't be more than 10 characters";
              }
              return null;
            },
            controller: _titleController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category Title',
                errorText: _hasInputError ? 'Value can\'t be empty' : null),
          ),
        ),
      ),
      actions: <Widget>[
        _isLoading? CircularProgressIndicator():FlatButton(
          child: Text('Add Catalog'),
          onPressed: () {
            if (key.currentState.validate()) {
              setState(() {
                _isLoading=true;
              });
              Provider.of<Categories>(context, listen: false)
                  .addCategory(_titleController.text, widget.currentUser.uid)
                  .then((_) {
                    setState(() {
                      _isLoading=false;
                    });
                Navigator.of(context).pop();
              }).catchError((err){
                setState(() {
                  _isLoading=false;
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(err.toString()),
                ));
                Navigator.of(context).pop();
              });
            }
          },
        )
      ],
    );
    showDialog(context: context, builder: (ctx) => addCategoryDialog);
  }
}
