import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<String>> fetchCategories() async {

  List<String> categories = [];

  final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list'));

  if (response.statusCode == 200) {
    var array = jsonDecode(response.body)['drinks'];
    array.forEach((category) => categories.add(category['strCategory']));
  } else {
    throw Exception("Couldn't fetch categories");
  }

  return categories;
}
