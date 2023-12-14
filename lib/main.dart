import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetprogmobile/http/cocktails.dart';
import 'package:projetprogmobile/views/pages/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projetprogmobile/views/pages/navigation.dart';

import 'http/categories.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail Recipes',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _loadInitialData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MainNavigation();
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}

Future<void> _loadInitialData() async {
  final prefs = await SharedPreferences.getInstance();

  // Check if cocktails are already stored
  if (prefs.getString("cocktails") == null || prefs.getString("cocktails") == "")
    {
    final cocktails = await fetchCocktails();
  final encodedCocktails = cocktails.map((cocktail) => cocktail.toJSON());
  await prefs.setString("cocktails", jsonEncode(encodedCocktails.toList()));
  }

  // Check if categories are already stored
  if (prefs.getString("categories") == null || prefs.getString("categories") == "") {
    final categories = await fetchCategories();
    await prefs.setString("categories", jsonEncode(categories));
  }
}

