import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  var itemId = null;
  final _form = GlobalKey<FormState>();
  var _editedItem =
      CategoryItem(id: '', title: '', description: '', imageUrl: '');
  var _initialValues = {
    'description': '',
    'title': '',
    'imageUrl': '',
  };
  var userId;
  File _imageFile;
  bool _isEditing = false;

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if(_imageFile==null){
      showDialog(context: context,builder: (ctx){
        return AlertDialog(
          title: Text('Error'),
          content: Text('No Image!'),
          actions: <Widget>[
            FlatButton(child: Text('Ok'),onPressed: ()=>Navigator.pop(context),)
          ],
        );
      });
    }
    if (!isValid&&_imageFile==null) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Categories>(context)
        .addItemToCategory(catId, _editedItem, _imageFile, _editedItem.imageUrl)
        .then((_) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Added! yaaay'),
      //   duration: Duration(seconds: 1),
      // ));

      Navigator.pop(context,{'itemId':itemId,'catId':catId},);
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
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _takePicFromGallarry() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
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
      Map<String, String> map =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      catId = map['catId'];
      itemId = map['itemId'];
      if (itemId != null) {
        _editedItem = Provider.of<Categories>(context)
            .findCategoryItemById(itemId, catId);
        _initialValues = {
          'id': _editedItem.id,
          'title': _editedItem.title,
          'description': _editedItem.description,
          'imageUrl': _editedItem.imageUrl,
        };
        setState(() {
          _isEditing = true;
        });
      }
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
                initialValue: _initialValues['title'],
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
                initialValue: _initialValues['description'],
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.purple),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: _imageFile == null && !_isEditing
                          ? Text('Pic an image')
                          : _isEditing
                              ? Image.network(_editedItem.imageUrl,
                                  fit: BoxFit.cover)
                              : Image.file(
                                  _imageFile,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton.icon(
                        icon: Icon(Icons.camera),
                        label: Text('Take Image'),
                        onPressed: _takePicFromCam,
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.image),
                        label: Text('Choose Image'),
                        onPressed: _takePicFromGallarry,
                      ),
                    ],
                  ),
                ],
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
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
