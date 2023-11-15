import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cocktails'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(20, (index) {
          return const Center(
              child: Divider() //CocktailListItem(cocktail: null),
              );
        }),
      ),
    );
  }
}
