import 'package:flutter/material.dart';
import 'package:projetprogmobile/views/cocktailitem.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(crossAxisCount: 2,
        children: List.generate(100, (index) {
          return Center(
            child: CocktailItem(title: 'Cocktail $index'),
          );
        }),
      ),
    );
  }
}