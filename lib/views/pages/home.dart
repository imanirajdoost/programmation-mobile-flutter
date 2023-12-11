import 'package:flutter/material.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/storage/cocktails.dart';
import 'package:projetprogmobile/views/cocktail_list_item.dart';
import 'package:projetprogmobile/views/cocktail_of_the_day_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Cocktail>> futureCocktails;
  late Future<Cocktail> cocktailOfTheDay;

  String sortType = 'Alphabet'; // Default sort type

  @override
  void initState() {
    super.initState();
    cocktailOfTheDay = getCocktailOfTheDay();
    futureCocktails = getCocktailsFromStorage();
  }

  List<Widget> buildCocktailLists(List<Cocktail> cocktails) {
    // Sorting logic
    if (sortType == 'Alphabet') {
      cocktails.sort((a, b) => a.name.compareTo(b.name));
    }

    Map<String, List<Cocktail>> groupedCocktails = {};
    if (sortType == 'Alcohol type' || sortType == 'Cocktail category') {
      for (var cocktail in cocktails) {
        var key = sortType == 'Alcohol type' ? cocktail.alcoholic.toString() : cocktail.category.toString();
        if (!groupedCocktails.containsKey(key)) {
          groupedCocktails[key] = [];
        }
        groupedCocktails[key]!.add(cocktail);
      }
    } else {
      groupedCocktails['All'] = cocktails;
    }

    List<Widget> lists = [];
    groupedCocktails.forEach((category, categoryCocktails) {
      lists.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(category, style: Theme.of(context).textTheme.headline6),
        ),
      );
      lists.add(
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: categoryCocktails.map((cocktail) => Center(child: CocktailListItem(cocktail: cocktail))).toList(),
        ),
      );
    });

    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder<List<Cocktail>>(
        future: futureCocktails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var cocktailLists = buildCocktailLists(snapshot.data ?? []);

          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: FutureBuilder<Cocktail>(
                  future: cocktailOfTheDay,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(height: 150, child: Center(child: Text('No Cocktail of the Day')));
                    }
                    return CocktailOfTheDayItem(cocktail: snapshot.data!);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("All Cocktails", style: Theme.of(context).textTheme.titleLarge),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.sort_by_alpha),
                            onPressed: () => setState(() => sortType = 'Alphabet'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.local_bar),
                            onPressed: () => setState(() => sortType = 'Alcohol type'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.category),
                            onPressed: () => setState(() => sortType = 'Cocktail category'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ...cocktailLists.map((widget) => SliverToBoxAdapter(child: widget)).toList(),
            ],
          );
        },
      ),
    );
  }
}
