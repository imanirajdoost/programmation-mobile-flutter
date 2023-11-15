
class Cocktail {
  final String id;
  final String name;
  final List<String> tags;
  final String category;
  final String? IBA;
  final String alcoholic;
  final String glass;
  final String instructions;
  final String thumbnailURL;
  final List<String> ingredients;
  final List<String> measures;

  Cocktail({
    required this.id,
    required this.name,
    required this.tags,
    required this.category,
    required this.IBA,
    required this.alcoholic,
    required this.glass,
    required this.instructions,
    required this.thumbnailURL,
    required this.ingredients,
    required this.measures
  });

  factory Cocktail.fromOriginalJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json['idDrink'] as String,
      name: json['strDrink'] as String,
      tags: (json['strTags'] ?? "").split(',') as List<String>,
      category: json['strCategory'] as String,
      IBA: json['strIBA'] as String?,
      alcoholic: json['strAlcoholic'] as String,
      glass: json['strGlass'] as String,
      instructions: json['strInstructions'] as String,
      thumbnailURL: json['strDrinkThumb'] as String,
      ingredients: ([
        json['strIngredient1'] ?? "",
        json['strIngredient2'] ?? "",
        json['strIngredient3'] ?? "",
        json['strIngredient4'] ?? "",
        json['strIngredient5'] ?? "",
        json['strIngredient6'] ?? "",
        json['strIngredient7'] ?? "",
        json['strIngredient8'] ?? "",
        json['strIngredient9'] ?? "",
        json['strIngredient10'] ?? "",
        json['strIngredient11'] ?? "",
        json['strIngredient12'] ?? "",
        json['strIngredient13'] ?? "",
        json['strIngredient14'] ?? "",
        json['strIngredient15'] ?? "",
      ].where((element) => element != "")).map((element) => element as String).toList(),
      measures: ([
        json['strMeasure1'] ?? "",
        json['strMeasure2'] ?? "",
        json['strMeasure3'] ?? "",
        json['strMeasure4'] ?? "",
        json['strMeasure5'] ?? "",
        json['strMeasure6'] ?? "",
        json['strMeasure7'] ?? "",
        json['strMeasure8'] ?? "",
        json['strMeasure9'] ?? "",
        json['strMeasure10'] ?? "",
        json['strMeasure11'] ?? "",
        json['strMeasure12'] ?? "",
        json['strMeasure13'] ?? "",
        json['strMeasure14'] ?? "",
        json['strMeasure15'] ?? "",
      ].where((element) => element != "")).map((element) => element as String).toList(),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'tags': tags,
      'category': category,
      'IBA': IBA,
      'alcoholic': alcoholic,
      'glass': glass,
      'instructions': instructions,
      'thumbnailURL': thumbnailURL,
      'ingredients': ingredients,
      'measures': measures
    };
  }

  factory Cocktail.fromJSON(Map<String, dynamic> json) {
    return Cocktail(
      id: json['id'] as String,
      name: json['name'] as String,
      tags: json['tags'].cast<String>(),
      category: json['category'] as String,
      IBA: json['IBA'] as String?,
      alcoholic: json['alcoholic'] as String,
      glass: json['glass'] as String,
      instructions: json['instructions'] as String,
      thumbnailURL: json['thumbnailURL'] as String,
      ingredients: json['ingredients'].cast<String>(),
      measures: json['measures'].cast<String>(),
    );
  }

}