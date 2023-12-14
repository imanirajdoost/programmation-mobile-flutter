
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

  String _selectedSort = 'Alphabet';
  Map<String, List<Cocktail>> _sortedCache = {}; // Cache for sorted lists

  List<String> categories = [];
  List<String> alcohols = [];

  String _titleText = 'All Cocktails';

  String _selectedFilter =
      ''; // New variable for the selected value of the second dropdown
  List<String> _filterOptions =
      []; // New variable for the list of options for the second dropdown

  Future<List<Cocktail>> sortAndGroupCocktails(
      List<Cocktail> cocktails, String sortBy, String filterBy) async {
    // Check cache first
    if (_sortedCache.containsKey(sortBy)) {
      return _sortedCache[sortBy]!;
    }

    Map<String, List<Cocktail>> groupedCocktails = {};

    categories = await getCategoriesFromStorage();
    alcohols = await getAlcohols();

    if (filterBy.isNotEmpty &&
        filterBy != 'All Categories' &&
        filterBy != 'All Types') {
      if (sortBy == 'Category') {
        cocktails = cocktails.where((c) => c.category == filterBy).toList();
      } else if (sortBy == 'Alcohol type') {
        cocktails =
            cocktails.where((c) => c.alcoholic.toString() == filterBy).toList();
      }
    }

    if (sortBy == 'Alphabet') {
      // No grouping, just sort by name
      cocktails.sort((a, b) => a.name.compareTo(b.name));
      return cocktails;
    } else if (sortBy == 'Category') {
      // Group by categories
      for (var category in categories) {
        groupedCocktails[category] =
            cocktails.where((c) => c.category == category).toList();
      }
    } else if (sortBy == 'Alcohol type') {
      // Group by alcohol types
      for (var alcoholType in alcohols) {
        groupedCocktails[alcoholType] = cocktails
            .where((c) => c.alcoholic.toString() == alcoholType)
            .toList();
      }
    }

    // Flatten the grouped cocktails into a single list for display
    List<Cocktail> sortedAndGroupedCocktails = [];
    groupedCocktails.forEach((key, value) {
      // Add a header or separator for each group
      // For now, just adding the cocktails
      sortedAndGroupedCocktails.addAll(value);
    });

    // Store the sorted and grouped list in the cache
    _sortedCache[sortBy] = sortedAndGroupedCocktails;

    return sortedAndGroupedCocktails;
  }

  void updateFilterOptions() {
    if (_selectedSort == 'Category') {
      _filterOptions = ['All Categories'] + categories;
    } else if (_selectedSort == 'Alcohol type') {
      _filterOptions = ['All Types'] + alcohols;
    } else {
      _filterOptions = [];
    }
    _selectedFilter = _filterOptions.isNotEmpty ? _filterOptions.first : '';
  }

  String getTitleText() {
    if (_selectedSort == 'Alphabet') {
      return 'All Cocktails';
    } else if (_selectedSort == 'Category') {
      return 'Filter';
    } else if (_selectedSort == 'Alcohol type') {
      return 'Filter';
    } else {
      return 'All Cocktails';
    }
  }

  String getAdditionalInfo(Cocktail cocktail) {
    if (_selectedSort == 'Alphabet') {
      return '';
    } else if (_selectedSort == 'Category') {
      return cocktail.category.toString();
    } else if (_selectedSort == 'Alcohol type') {
      return cocktail.alcoholic.toString();
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          const Text("Sort by: "),
          // Add some space
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: _selectedSort,
            onChanged: (String? newValue) {
              if (newValue != null && newValue != _selectedSort) {
                setState(() {
                  _selectedSort = newValue;
                  _titleText = getTitleText();
                  updateFilterOptions();
                  futureCocktails = getCocktailsFromStorage().then((cocktails) {
                    return sortAndGroupCocktails(
                        cocktails, _selectedSort, _selectedFilter);
                  });
                });
              }
            },
            items: <String>['Alphabet', 'Category', 'Alcohol type']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
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
                                ? CocktailOfTheDayItem(
                                    cocktail: cocktailSnapshot.data!)
                                : const Text('No Cocktail of the Day'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              _titleText,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            // make the drop down go all the way to the right
                            const Spacer(),
                            // New Dropdown for filtering based on the selected sort type
                            if (_filterOptions
                                .isNotEmpty) // Show this dropdown only if there are options
                              DropdownButton<String>(
                                value: _selectedFilter,
                                onChanged: (String? newValue) {
                                  if (newValue != null &&
                                      newValue != _selectedFilter) {
                                    setState(() {
                                      _selectedFilter = newValue;
                                      futureCocktails =
                                          getCocktailsFromStorage()
                                              .then((cocktails) {
                                        return sortAndGroupCocktails(cocktails,
                                            _selectedSort, _selectedFilter);
                                      });
                                    });
                                  }
                                },
                                items: _filterOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Center(
                          child: CocktailListItem(
                              cocktail: gridSnapshot.data![index],
                              additionalInfo:
                                  getAdditionalInfo(gridSnapshot.data![index])),
                        );
                      },
                      childCount: gridSnapshot.data!.length,
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

    futureCocktails = getCocktailsFromStorage().then((cocktails) {
      return sortAndGroupCocktails(cocktails, _selectedSort, _selectedFilter);
    });
  }
}
