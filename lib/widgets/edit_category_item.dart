import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/categories.dart';

class EditCategoryItem extends StatefulWidget {
  final String catId;
  final Key key;

  EditCategoryItem(this.catId, this.key);

  @override
  _EditCategoryItemState createState() => _EditCategoryItemState();
}

class _EditCategoryItemState extends State<EditCategoryItem> {
  Category cat;
  bool _isEditing;
  bool _isInit = false;
  bool _isLoading = false;
  Widget leading = Text(
    '',
    style: TextStyle(fontSize: 20),
  );
  Icon middle = Icon(
    Icons.edit,
    size: 20,
    color: Colors.green,
  );
  Icon end = Icon(
    Icons.delete,
    size: 20,
    color: Colors.red,
  );
  var _titleController = TextEditingController();
  @override
  void initState() {
    cat = Provider.of<Categories>(context, listen: false)
        .findCategoryById(widget.catId);
    _isEditing = false;
    leading = Text(
      Provider.of<Categories>(context, listen: false)
          .findCategoryById(widget.catId)
          .title,
      style: TextStyle(fontSize: 20),
    );
    _titleController = TextEditingController(text: cat.title);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      //leading=Text(widget.cat.title,style: TextStyle(fontSize: 30),);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void switchEditMode() {
    setState(() {
      if (this._isEditing) {
        this.middle = _isLoading
            ? CircularProgressIndicator()
            : Icon(Icons.check, color: Colors.green);
        this.end = Icon(Icons.close, color: Colors.red);
        this.leading = TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: cat.title),
        );
      } else {
        this.middle = Icon(Icons.edit, color: Colors.green);
        this.end = Icon(Icons.delete, color: Colors.red);
        this.leading = Text(
          cat.title,
          style: TextStyle(fontSize: 20),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 80,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: leading,
              ),
              IconButton(
                icon: middle,
                onPressed: () {
                  if (this.middle.icon == Icons.edit) {
                    _isEditing = true;
                    switchEditMode();
                  } else {
                    Provider.of<Categories>(context, listen: false)
                        .updateCategoryTitle(cat.id, _titleController.text)
                        .then((_) {
                      cat.title = _titleController.text;
                      _isEditing = false;
                      Scaffold.of(context).removeCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Edited !'),
                        duration: Duration(seconds: 2),
                      ));
                      switchEditMode();
                    }).catchError((err) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: Text(err.toString()),
                            );
                          });
                      _isEditing = false;
                    });
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: end,
                onPressed: () {
                  if (this.end.icon == Icons.delete) {
                    setState(() {
                      _isLoading = true;
                    });
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          // Show Confirm Dialog
                          return AlertDialog(
                            content: Text('Are u sure ?! '),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  Provider.of<Categories>(context,
                                          listen: false)
                                      .deleteCategory(cat.id)
                                      .then((_) {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Deleted!'),
                                      ),
                                    );
                                  });
                                },
                              ),
                              FlatButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  } else {
                    _isEditing = false;
                    switchEditMode();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
