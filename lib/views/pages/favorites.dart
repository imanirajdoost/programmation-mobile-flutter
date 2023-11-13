import 'package:flutter/material.dart';
import 'package:projetprogmobile/views/cocktail_list_item.dart';

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
        children: List.generate(20, (index) {
          return Center(
            child: CocktailListItem(title: 'Cocktail $index', imageUrl: 'https://www.thecocktaildb.com/images/media/drink/nkwr4c1606770558.jpg'),
          );
        }),
      ),
    );
  }
}