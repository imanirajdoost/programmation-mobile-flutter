import 'package:flutter/material.dart';
import 'package:projetprogmobile/models/cocktails.dart';

class CocktailPage extends StatefulWidget {
  final Cocktail cocktail;

  const CocktailPage({super.key, required this.cocktail});

  @override
  State<CocktailPage> createState() => _CocktailPageState();
}

class _CocktailPageState extends State<CocktailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail.name),
      ),
      body: Center(
        child: Text('Details for ${widget.cocktail.name}'),
      ),
    );
  }
}
