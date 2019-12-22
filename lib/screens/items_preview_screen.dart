import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_all_me/models/category_item.dart';
import 'package:save_all_me/screens/add_item_screen.dart';

import '../providers/categories.dart';

class ItemPreviewScreen extends StatelessWidget {
  String catId;
  String itemId;

  ItemPreviewScreen(this.catId, this.itemId);
  static const routeName = '/item_preview_screen';

  void _showItemAndGetData(BuildContext context) async {
    final result2 = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddItemScreen(),
          settings:
              RouteSettings(arguments: {'itemId': itemId, 'catId': catId})),
    );

    catId = result2['catId'];
    itemId = result2['itemId'];
    print('start');
    print(catId);
    print(itemId);
    print('got it ');
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context).settings.arguments as Map<String, Object>;
    // catId = args['categoryId'];
    // itemId = args['itemId'];
    //final item = args['itemData'] as CategoryItem;

    final item = Provider.of<Categories>(context, listen: false)
        .findCategoryItemById(itemId, catId);
    
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text('Info'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              //Navigator.pushNamed(context, AddItemScreen.routeName,arguments: {'itemId': itemId, 'catId': catId});
              _showItemAndGetData(context);
            },
          )
        ],
      ),
      body: Container(
        // color: Colors.grey.shade300,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: screenSize.width,
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: itemId,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.fill,
                        height: screenSize.height * .5,
                        width: screenSize.width,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          border:
                              Border.all(color: Theme.of(context).accentColor),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black45,
                                blurRadius: 10,
                                offset: Offset(5, 5))
                          ],
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          item.title,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
