import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/categories.dart';

class EditCategoryItem extends StatefulWidget {
  final Category cat;
  final Key key;

  EditCategoryItem(this.cat, this.key);

  @override
  _EditCategoryItemState createState() => _EditCategoryItemState();
}

class _EditCategoryItemState extends State<EditCategoryItem> {
  bool _isEditing;
  bool _isInit = false;
  Widget leading = Text(
    '',
    style: TextStyle(fontSize: 20),
  );
  Icon middle = Icon(
    Icons.edit,
    size: 30,
    color: Colors.green,
  );
  Icon end = Icon(
    Icons.delete,
    size: 30,
    color: Colors.red,
  );
  var _titleController = TextEditingController(text: '');
  @override
  void initState() {
    _isEditing = false;
    leading = Text(
      widget.cat.title,
      style: TextStyle(fontSize: 20),
    );
    _titleController = TextEditingController(text: widget.cat.title);
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
        this.middle = Icon(Icons.check, color: Colors.green);
        this.end = Icon(Icons.close, color: Colors.red);
        this.leading = TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: widget.cat.title),
        );
      } else {
        this.middle = Icon(Icons.edit, color: Colors.green);
        this.end = Icon(Icons.delete, color: Colors.red);
        this.leading = Text(
          widget.cat.title,
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
                  setState(() {
                    if (this.middle.icon == Icons.edit) {
                      _isEditing = true;
                      switchEditMode();
                    } else {
                      Provider.of<Categories>(context).updateCategoryTitle(
                          widget.cat.id, _titleController.text);
                      _isEditing = false;
                      switchEditMode();
                    }
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: end,
                onPressed: () {
                  if (this.end.icon == Icons.delete) {
                    Provider.of<Categories>(context, listen: false)
                        .deleteCategory(widget.cat.id);
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
