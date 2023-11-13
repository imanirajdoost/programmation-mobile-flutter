import 'package:flutter/material.dart';

class CocktailItem extends StatefulWidget {
  final String title;
  final String imageUrl; // URL of the cocktail image
  final bool isLiked; // Indicates if the cocktail is liked

  const CocktailItem({super.key, required this.title, required this.imageUrl, this.isLiked = false});

  @override
  State<CocktailItem> createState() => _CocktailItemState();
}

class _CocktailItemState extends State<CocktailItem> {
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
        // Define the action when the card is tapped
        print("${widget.title} tapped!");
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
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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