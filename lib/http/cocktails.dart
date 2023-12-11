import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetprogmobile/models/cocktails.dart';

Future<List<Cocktail>> fetchCocktails() async {

  List<Cocktail> cocktails = [];
  List<String> alphanumericCharacters = List.generate(36, (index) {
    if (index < 10) {
      return index.toString();
    } else {
      // ASCII value for 'A' is 65, so add the ASCII value to get letters
      return String.fromCharCode(65 + (index - 10));
    }
  });

  for (var char in alphanumericCharacters) {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?f=$char'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var drinks = jsonDecode(response.body)['drinks'];

      if (drinks == null) {
        continue;
      }

      drinks.forEach((drink) => cocktails.add(Cocktail.fromOriginalJson(drink)));
    } else {
      throw Exception('Failed to load cocktails');
    }
  }
  return cocktails;
}
