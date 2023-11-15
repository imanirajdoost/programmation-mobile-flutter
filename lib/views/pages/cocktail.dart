import 'package:flutter/material.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:share/share.dart';

class CocktailPage extends StatefulWidget {
  final Cocktail cocktail;

  const CocktailPage({super.key, required this.cocktail});

  @override
  State<CocktailPage> createState() => _CocktailPageState();
}

class _CocktailPageState extends State<CocktailPage> {
  @override
  Widget build(BuildContext context) {
    // Determine the shorter length of the two lists
    int listLength = widget.cocktail.ingredients.length;
    if (widget.cocktail.measures.length < listLength) {
      listLength = widget.cocktail.measures.length;
    }

    // Function to create the shareable text content
    String createShareContent() {
      String ingredientsText = widget.cocktail.ingredients
          .asMap()
          .entries
          .map((entry) => "${entry.value} - ${widget.cocktail.measures.length >
          entry.key ? widget.cocktail.measures[entry.key] : 'N/A'}")
          .join('\n');

      return "${widget.cocktail
          .name}\n\nIngredients:\n$ingredientsText\n\nInstructions:\n${widget
          .cocktail.instructions}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display the thumbnail image if available
            Image.network(widget.cocktail.thumbnailURL),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Display the cocktail name if available
                  Text(
                    widget.cocktail.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  // Display ingredients and their measures if available
                  if (listLength > 0)
                    Text(
                      'Ingredients:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  for (int i = 0; i < listLength; i++)
                    Text('${widget.cocktail.ingredients[i]} - ${widget.cocktail.measures.isNotEmpty ? widget.cocktail.measures[i] : 'N/A'}'),
                  const SizedBox(height: 20),
                  // Display the instructions if available
                  Text(
                    'Instructions:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(widget.cocktail.instructions),
                ],
              ),
            ),
          ],
        ),
      ),
    // Floating action button for sharing
    floatingActionButton: FloatingActionButton(
    child: const Icon(Icons.share),
    onPressed: () {
    Share.share(createShareContent());
    },
    ),
    );
  }
}
