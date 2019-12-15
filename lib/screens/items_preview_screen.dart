import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

class ItemPreviewScreen extends StatelessWidget {
  String catId;
  String itemId;
  static const routeName = '/item_preview_screen';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    catId = args['categoryId'];
    itemId = args['itemId'];
    final item = Provider.of<Categories>(context, listen: false)
        .findCategoryItemById(itemId, catId);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Container(
        width: screenSize.width,
        child: Card(
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                height: 8,
              ),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                item.description,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
