import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:save_all_me/providers/auth_service.dart';
import 'package:uuid/uuid.dart';

import '../providers/categories.dart';
import '../models/category_item.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add_item_screen';

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  var catId = '';
  final _form = GlobalKey<FormState>();
  var _editedItem =
      CategoryItem(id: '', title: '', description: '', imageUrl: '');
  var userId;
  File _imageFile;

  

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    print(userId);
    _form.currentState.save();
    Provider.of<Categories>(context)
        .addItemToCategory(catId, _editedItem,_imageFile)
        .then((_) {
          Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Added! yaaay'),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _isLoading = false;
      });
      
      Navigator.pop(context);
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });
      print(err.toString());
    });
  }

  Future<void> _takePicFromCam() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if(imageFile!=null){
      setState(() {
      _imageFile=imageFile;
      });
      
    }
  }



  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      catId = ModalRoute.of(context).settings.arguments as String;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedItem = CategoryItem(
                    title: value,
                    id: _editedItem.id,
                    description: _editedItem.description,
                    imageUrl: _editedItem.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedItem = CategoryItem(
                    title: _editedItem.title,
                    id: _editedItem.id,
                    description: value,
                    imageUrl: _editedItem.imageUrl,
                  );
                },
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.purple),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: _imageFile==null
                          ? Text('Pic an image')
                          : Image.file(
                              _imageFile,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                 
                  Expanded(
                     child:FlatButton.icon(
                    icon: Icon(Icons.camera),
                    label: Text('Take Image'),
                    onPressed: _takePicFromCam,
                  ),
                    // child: TextFormField(
                    //   focusNode: _imageUrlFocusNode,
                    //   controller: _imageUrlController,
                    //   decoration: InputDecoration(labelText: 'Image URl'),
                    //   keyboardType: TextInputType.text,
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please enter an image URL.';
                    //     }
                    //     if (!value.startsWith('http') &&
                    //         !value.startsWith('https')) {
                    //       return 'Please enter a valid URL.';
                    //     }
                    //     if (!value.endsWith('.png') &&
                    //         !value.endsWith('.jpg') &&
                    //         !value.endsWith('.jpeg')) {
                    //       return 'Please enter a valid image URL.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _editedItem = CategoryItem(
                    //       title: _editedItem.title,
                    //       id: _editedItem.id,
                    //       description: _editedItem.description,
                    //       imageUrl: value,
                    //     );
                    //   },
                    // ),
                  ),
                ],
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text(
                        'Add Item',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _saveForm,
                      color: Theme.of(context).primaryColor,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
