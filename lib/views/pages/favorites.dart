import 'package:flutter/material.dart';
import 'package:projetprogmobile/storage/cocktails.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/views/cocktail_favorite_list_item.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<List<Cocktail>> getLikedCocktails() async {
    List<Cocktail> tempCocktails = [];
    await getCocktailsFromStorage().then((cocktails) async {
      // for each cocktail, search the id in the shared preferences
      for (var cocktail in cocktails) {
        await getLikedCocktailFromCache(cocktail.id).then((value) {
          if (value != null) {
            tempCocktails.add(cocktail);
          }
        });
      }
    });
    return Future.value(tempCocktails);
  }

  Future<List<Cocktail>> cocktails = Future.value([]);

  @override
  void initState() {
    super.initState();
    cocktails = getLikedCocktails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cocktails'),
      ),
      body: FutureBuilder<List<Cocktail>>(
        future: cocktails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the future is still running, show a loading spinner
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error, display it
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // If the list is empty, show a "List is empty" message
            return const Center(
                    child: Text(
                        'The list is empty. Add cocktails from the home page!'));
          } else if (snapshot.hasData) {
            // If there's data, show the list
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CocktailFavoriteListItem(
                  cocktail: snapshot.data![index],
                  onLikeChanged: (bool isLiked) {
                    setState(() {
                      cocktails = getLikedCocktails();
                    });
                  },
                );
              },
            );
          } else {
            // If none of the above, show a generic message
            return const Center(
                    child: Text(
                        'The list is empty. Add cocktails from the home page!')
            );
          }
        },
      ),
    );
  }
}
