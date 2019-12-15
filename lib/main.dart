import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_service.dart';

import './screens/splash_screen.dart';
import './screens/items_preview_screen.dart';
import './screens/authenticate_screen.dart';
import './screens/edit_categories_screen.dart';
import './providers/categories.dart';
import './screens/category_screen.dart';
import './screens/categories_overview_screen.dart';
import './screens/add_item_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Categories>(
          create: (_) => Categories(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: Consumer<AuthService>(

        builder: (context, auth, __) => MaterialApp(
          title: 'Save All Me',
          theme: ThemeData(primarySwatch: Colors.purple),
          home:  FutureBuilder<FirebaseUser>(
            future: auth.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.error != null) {
                  print('error');
                  return Text(snapshot.error.toString());
                }
                return snapshot.hasData
                    ? CategoriesOverviewScreen(snapshot.data)
                    : AuthScreen();
              } else {
                return  SplashScreen();
              }
            },
          ),
          routes: {
            AddItemScreen.routeName: (context) => AddItemScreen(),
            CategoryScreen.routeName: (context) => CategoryScreen(),
            EditCategoriesScreen.routeName: (context) => EditCategoriesScreen(),
            ItemPreviewScreen.routeName:(context)=>ItemPreviewScreen(),
          },
        ),
      ),
    );
  }
}
