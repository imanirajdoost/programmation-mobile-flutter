import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetprogmobile/models/cocktails.dart';

Future<List<Cocktail>> fetchCocktails() async {
  final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s='));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var drinks = jsonDecode(response.body)['drinks'];
    List<Cocktail> cocktails = [];

    drinks.forEach((drink) => cocktails.add(Cocktail.fromJson(drink)));

    return cocktails;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load cocktails');
  }
}
