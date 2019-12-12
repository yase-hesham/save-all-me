import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_item_screen.dart';
import '../widgets/category_item_widget.dart';
import '../models/category.dart';
import '../providers/categories.dart';

class CategoryWidget extends StatelessWidget {
  final String categoryId;

  CategoryWidget({this.categoryId});

  @override
  Widget build(BuildContext context) {
    final deviceScreen = MediaQuery.of(context).size;

    Category cat = Provider.of<Categories>(context, listen: false)
        .findCategoryById(categoryId);

    return Column(
      children: <Widget>[
        CustomPaint(
          painter: ShapesPainter(),
          child: Container(
            height: 30,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: FittedBox(
                    child: Text(
                      cat.title,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'MyHappyEnding'
                      ),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).primaryColor,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AddItemScreen.routeName,
                          arguments: cat.id);
                    }),
              ],
            ),
          ),
        ),
        cat.items.isEmpty
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.purple),
                child: Text('No items'))
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(5, 5),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(horizontal: 2),
                height: deviceScreen.height * .25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cat.items.length,
                  itemBuilder: (ctx, index) {
                    return CategoryItemWidget(
                      itemId: cat.items[index].id,
                      categoryId: categoryId,
                    );
                  },
                ),
              ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.purple;
    var rect = Rect.fromLTRB(2, 0, size.width / 2, size.height);
    var rrect = RRect.fromRectAndCorners(rect,
        topLeft: Radius.circular(20),
        topRight: Radius.circular(18),
        bottomRight: -Radius.elliptical(20, 20));

    canvas.drawRRect(rrect, paint);
    paint.color = Colors.purple;
    //paint.style = PaintingStyle.stroke;
    var path = Path();
    paint.strokeWidth = 2;
    path.moveTo(size.width / 2 - 1.4, 0);
    path.lineTo(size.width / 2 - 1.4, size.height);
    path.lineTo(size.width / 2 + 20 - 1.4, size.height);
    path.quadraticBezierTo(size.width / 2 + 2, size.height * .7,
        size.width / 2 - 1.4, size.height * .33);
    //path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
