import 'package:flutter/material.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/views/pages/cocktail.dart';

class CocktailFavoriteListItem extends StatefulWidget {
  final Cocktail cocktail;
  final Function(bool) onLikeChanged; // Add this callback

  const CocktailFavoriteListItem(
      {super.key, required this.cocktail, required this.onLikeChanged});

  @override
  State<CocktailFavoriteListItem> createState() =>
      _CocktailFavoriteListItemState();
}

class _CocktailFavoriteListItemState extends State<CocktailFavoriteListItem> {
  late Cocktail cocktail;

  @override
  void initState() {
    super.initState();
    cocktail = widget.cocktail; // Initialize name here
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CocktailPage(
              cocktail: widget.cocktail,
              onLikeChanged: (bool isLiked) {
                widget.onLikeChanged(isLiked);
              },
            ),
          ),
        );
      },
      child: SizedBox(
        height: 140, // Set the fixed height of the card
        width: double.infinity, // Set the width to take the full width available
        child: Card(
          margin: const EdgeInsets.all(8),
          color: Colors.grey[870], // Light dark background color for the card
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Image.network(
                  widget.cocktail.thumbnailURL,
                  width: 80, // Set a fixed width for the image
                  height: 80, // Set a fixed height for the image
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.cocktail.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.cocktail.instructions, // Assuming there's a description field
                          style: const TextStyle(
                            fontSize: 14, // Smaller font size for the description
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
