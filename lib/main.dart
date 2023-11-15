import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetprogmobile/http/cocktails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projetprogmobile/views/pages/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final cocktails = await fetchCocktails();
  final encodedCocktails = cocktails.map((cocktail) => cocktail.toJSON());
  await prefs.setString("cocktails", jsonEncode(encodedCocktails.toList()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail Recipes',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}
