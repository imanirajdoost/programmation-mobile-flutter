import 'dart:convert';

import 'package:projetprogmobile/models/cocktails.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Cocktail>> getCocktailsFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  String cocktailsString = prefs.getString('cocktails') ?? "";
  List<dynamic> decodedJson = jsonDecode(cocktailsString);
  List<Cocktail> cocktails = decodedJson.map((elem) => Cocktail.fromJSON(elem)).toList();
  return cocktails;
}