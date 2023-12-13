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
    setAdditionalInfo();
  }

  void setAdditionalInfo()
  {

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
          // Stretch to fill the card
          children: <Widget>[
            Expanded(
              child: Image.network(
                widget.cocktail.thumbnailURL,
                fit: BoxFit.cover, // Cover the card area
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.cocktail.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            // if additionalInfo is not empty, display it
            if (additionalInfo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  additionalInfo,
                  style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
