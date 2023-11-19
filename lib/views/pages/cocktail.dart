import 'package:flutter/material.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/storage/cocktails.dart';
import 'package:share/share.dart';

class CocktailPage extends StatefulWidget {
  final Cocktail cocktail;
  final Function(bool) onLikeChanged; // Add this callback

  const CocktailPage({super.key, required this.cocktail,required this.onLikeChanged});

  @override
  State<CocktailPage> createState() => _CocktailPageState();
}

class _CocktailPageState extends State<CocktailPage> {
  bool isLiked = false; // Variable to track if the cocktail is liked

  @override
  void initState() {
    super.initState();
    _loadIsLiked();
  }

  void _loadIsLiked() async {
    String? likedCocktail = await getLikedCocktail(widget.cocktail.id);
    setState(() {
      isLiked = likedCocktail != null;
    });
  }

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
          .map((entry) =>
              "${entry.value} - ${widget.cocktail.measures.length > entry.key ? widget.cocktail.measures[entry.key] : 'N/A'}")
          .join('\n');

      return "${widget.cocktail.name}\n\nIngredients:\n$ingredientsText\n\nInstructions:\n${widget.cocktail.instructions}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.network(widget.cocktail.thumbnailURL),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      if (isLiked) {
                        saveLikedCocktail(widget.cocktail.id);
                      } else {
                        removeLikedCocktail(widget.cocktail.id);
                      }
                    });
                    widget.onLikeChanged(isLiked); // Pop with the like status
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.cocktail.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  if (listLength > 0)
                    Text(
                      'Ingredients:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  for (int i = 0; i < listLength; i++)
                    Text(
                        '${widget.cocktail.ingredients[i]} - ${widget.cocktail.measures.isNotEmpty ? widget.cocktail.measures[i] : 'N/A'}'),
                  const SizedBox(height: 20),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.share),
        onPressed: () {
          Share.share(createShareContent());
        },
      ),
    );
  }
}
