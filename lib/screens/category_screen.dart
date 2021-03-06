import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_all_me/widgets/category_item_widget.dart';

import '../models/category_item.dart';
import '../providers/categories.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category_screen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Widget appBarTitle =  Text(
    '',
    style:  TextStyle(color: Colors.white),
  );
  Icon actionIcon =  Icon(
    Icons.search,
    color: Colors.white,
  );
  final TextEditingController _searchQuery =  TextEditingController();
  bool _isSearching;
  String _searchText = "";
  

  _CategoryScreenState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    final String catId = ModalRoute.of(context).settings.arguments.toString();
    final List<CategoryItem> catItems =
        Provider.of<Categories>(context, listen: false).categoryItems(catId);
    final String catTitle = Provider.of<Categories>(context, listen: false)
        .findCategoryById(catId)
        .title;
    // appBarTitle =  Text(
    //   catTitle,
    //   style:  TextStyle(color: Colors.white),
    // );
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          buildBar(context),
          _isSearching
              ? _buildFilteredItems(catId, catItems)
              : _buildItems(catId, catItems)
        ],
      ),
    );
  }

  SliverGrid _buildFilteredItems(String catId, List<CategoryItem> catItems) {
    if (_searchText.isEmpty) {
      return _buildItems(catId, catItems);
    } else {
      List<CategoryItem> _searchList = Provider.of<Categories>(context,listen: false)
          .findItemsByCatIdAndTitle(catId, _searchText);
      print(_searchList.length);
      return _buildItems(catId, _searchList);
    }
  }

  SliverGrid _buildItems(String catId, List<CategoryItem> catItems) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
          (ctx, index) => CategoryItemWidget(
                categoryId: catId,
                itemId: catItems[index].id,
              ),
          childCount: catItems.length),
    );
  }

  Widget buildBar(BuildContext context) {
    return  SliverAppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
           IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon =  Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle =  TextField(
                    controller: _searchQuery,
                    style:  TextStyle(
                      color: Colors.white,
                    ),
                    decoration:  InputDecoration(
                        prefixIcon:  Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle:  TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon =  Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle =  Text(
        "Search Sample",
        style:  TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}
