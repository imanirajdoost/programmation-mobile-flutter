import 'package:flutter/material.dart';
import 'package:projetprogmobile/views/pages/cocktail.dart';

class CocktailListItem extends StatefulWidget {
  final String title;
  final String imageUrl; // URL of the cocktail image
  final bool isLiked; // Indicates if the cocktail is liked

  const CocktailListItem({super.key, required this.title, required this.imageUrl, this.isLiked = false});

  @override
  State<CocktailListItem> createState() => _CocktailListItemState();
}

class _CocktailListItemState extends State<CocktailListItem> {
  late String name;
  late String imageUrl; // URL of the cocktail image
  late bool isLiked = false; // Indicates if the cocktail is liked

  @override
  void initState() {
    super.initState();
    name = widget.title; // Initialize name here
    imageUrl = widget.imageUrl; // Initialize imageUrl here
    isLiked = widget.isLiked; // Initialize isLiked here
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CocktailPage(cocktailName: widget.title),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill the card
          children: <Widget>[
            Expanded(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover, // Cover the card area
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}