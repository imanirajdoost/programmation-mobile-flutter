import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getCocktailsFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  String categories = prefs.getString('categories') ?? "";
  List<String> decodedJson = jsonDecode(categories);
  return decodedJson;
}