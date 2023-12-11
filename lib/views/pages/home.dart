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
  String selectedAlcohol = 'All'; // Selected alcohol for sorting
  String selectedCategory = 'All'; // Selected category for sorting

  void sortCocktails(List<Cocktail> cocktails) {
    if (sortType == 'Alphabet') {
      cocktails.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortType == 'Alcohol type') {
      // Filter by selected alcohol type, then sort alphabetically
      cocktails.sort((a, b) => a.alcoholic.toString().compareTo(b.alcoholic.toString()));
    } else if (sortType == 'Cocktail category') {
      // Filter by selected category, then sort alphabetically
      cocktails.sort((a, b) => a.category.toString().compareTo(b.category.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder<Cocktail>(
        future: cocktailOfTheDay,
        builder: (context, cocktailSnapshot) {
          return FutureBuilder<List<Cocktail>>(
            future: futureCocktails,
            builder: (context, gridSnapshot) {
              if (cocktailSnapshot.connectionState == ConnectionState.waiting ||
                  gridSnapshot.connectionState == ConnectionState.waiting) {
                // Show loading spinner if either future is still loading
                return const CircularProgressIndicator();
              } else if (cocktailSnapshot.hasError) {
                // Handle errors for cocktail of the day
                return Text('Error: ${cocktailSnapshot.error}');
              } else if (gridSnapshot.hasError) {
                // Handle errors for grid cocktails
                return Text('Error: ${gridSnapshot.error}');
              }

              var cocktails = gridSnapshot.data ?? [];
              // Apply sorting here based on sortType

              return CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Cocktail of the Day",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: Center(
                            child: cocktailSnapshot.hasData
                                ? CocktailOfTheDayItem(cocktail: cocktailSnapshot.data!)
                                : const Text('No Cocktail of the Day'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "All Cocktails",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.sort_by_alpha),
                                    onPressed: () {
                                      setState(() {
                                        // Sort by alphabet logic
                                        sortType = 'Alphabet';
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.local_bar),
                                    onPressed: () {
                                      setState(() {
                                        // Sort by Alcohol type logic
                                        sortType = 'Alcohol Type';
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.category),
                                    onPressed: () {
                                      setState(() {
                                        // Sort by Cocktail category logic
                                        sortType = 'Category';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        Text(
                          'Sorted by: $sortType',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Center(
                          child: CocktailListItem(cocktail: cocktails[index]),
                        );
                      },
                      childCount: cocktails.length,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    cocktailOfTheDay = getCocktailOfTheDay();
    futureCocktails = getCocktailsFromStorage();
  }
}
