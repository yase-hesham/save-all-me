import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/category_item.dart';
import '../providers/categories.dart';

class CategoryItemWidget extends StatelessWidget {
  final String itemId;
  final String categoryId;

  CategoryItemWidget({this.itemId, this.categoryId});

  @override
  Widget build(BuildContext context) {
    final CategoryItem itemData =
        Provider.of<Categories>(context, listen: false)
            .findCategoryItemById(itemId, categoryId);
    final deviceScreen = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print(itemId);
      },
      child: Container(
        width: deviceScreen.width * .4,
        height: deviceScreen.width * .5,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.network(
                  itemData.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.purple.shade400,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  width: deviceScreen.width * .4,
                  alignment: Alignment.center,
                  child: FittedBox(
                      child: Text(itemData.title,
                          style: TextStyle(color: Colors.black))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
