import 'package:flutter/material.dart';
import 'package:projetprogmobile/storage/cocktails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/views/pages/cocktail.dart';

class CocktailListItem extends StatefulWidget {
  final Cocktail cocktail;
  final bool isLiked; // Indicates if the cocktail is liked
  final String additionalInfo;

  const CocktailListItem(
      {super.key, required this.cocktail, required this.additionalInfo, this.isLiked = false, });

  @override
  State<CocktailListItem> createState() => _CocktailListItemState();
}

class _CocktailListItemState extends State<CocktailListItem> {
  late Cocktail cocktail;
  late bool isLiked = false; // Indicates if the cocktail is liked
  late String additionalInfo = '';

  @override
  void initState() {
    super.initState();
    cocktail = widget.cocktail; // Initialize name here
    isLiked = widget.isLiked; // Initialize isLiked here
    additionalInfo = widget.additionalInfo; // Initialize additionalInfo here

    setIsLiked();
  }

  Future<void> setIsLiked() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = prefs.getString(cocktail.id) != null;
    });
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
                  setState(() {
                    this.isLiked = isLiked;
                  });
                }),
          ),
        );
        await setIsLiked(); // Refresh the like status after returning
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              // Use Expanded to allow the image to take up available space
              child: Image.network(
                widget.cocktail.thumbnailURL,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.cocktail.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Adjusted font size
              ),
            ),
            if (additionalInfo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  additionalInfo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  isLiked = !isLiked; // Toggle the liked status
                  if (isLiked) {
                    saveLikedCocktail(cocktail.id);
                  } else {
                    removeLikedCocktail(cocktail.id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }


}
