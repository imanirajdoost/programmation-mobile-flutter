import 'package:flutter/material.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/storage/cocktails.dart';
import 'package:projetprogmobile/views/cocktail_list_item.dart';
import 'package:projetprogmobile/views/search_dropdown_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late Future<List<Cocktail>> futureCocktails;
  String searchQuery = '';
  List<Cocktail> filteredCocktails = [];
  final TextEditingController searchController = TextEditingController();

  String filterMode = 'Name'; // Variable to store the current filter mod

  String nearestIngredient = '';

  ValueNotifier<String> nearestIngredientNotifier = ValueNotifier('');

  void updateNearestIngredient(List<Cocktail> cocktails, String query) {

    if(filterMode == 'Name') {
      nearestIngredient = '';
      nearestIngredientNotifier.value = nearestIngredient;
      return;
    }

    if(query.isEmpty) {
      nearestIngredient = '';
      nearestIngredientNotifier.value = nearestIngredient;
      return;
    }


    for (var cocktail in cocktails) {
      for (var ingredient in cocktail.ingredients) {
        // Check for partial match first
        if (ingredient.toLowerCase().contains(query.toLowerCase())) {
          nearestIngredient = ingredient;
          break;
        }
      }
    }

    // Logic to find the nearest ingredient
    // Once found, update the nearestIngredientNotifier
    nearestIngredientNotifier.value = nearestIngredient;
  }

  void setFilterMode(String mode) {
    setState(() {
      filterMode = mode;
      updateNearestIngredient(filteredCocktails, searchQuery);
    });
  }

  @override
  void initState() {
    super.initState();
    futureCocktails = getCocktailsFromStorage();
  }

  void filterCocktails(List<Cocktail> cocktails, String query) {
    if (query.isEmpty) {
      filteredCocktails = cocktails;
    } else {
      if (filterMode == 'Name') {
        filteredCocktails = cocktails.where((cocktail) => cocktail.name.toLowerCase().contains(query.toLowerCase())).toList();
      } else { // 'Ingredient' filter mode
        filteredCocktails = cocktails.where((cocktail) =>
            cocktail.ingredients.any((ingredient) => ingredient.toLowerCase().contains(query.toLowerCase()))
        ).toList();
      }
    }
  }

  String getAdditionalInfo(Cocktail cocktail) {
    if (filterMode == 'Name') {
      return '';
    } else { // 'Ingredient' filter mode
      // return cocktail.ingredients.join(', ');
      return nearestIngredient;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Text field with search icon
    final searchField = TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              searchQuery = '';
              updateNearestIngredient(filteredCocktails, searchQuery);
              searchController.clear();  // Clear the text in the controller
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
          updateNearestIngredient(filteredCocktails, searchQuery); // Call to update immediately
        });
      },
    );


    // Search field and button
    final searchFieldAndButton = Row(
      children: [
        Expanded(child: searchField),
      ],
    );

    // Add a key to FutureBuilder
    final futureBuilderKey = ValueKey(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Cocktails'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            searchFieldAndButton,
            const SizedBox(height: 10),
             Row(children: [
              const Text('Filter by:'),
              const SizedBox(width: 30),
              Expanded(child:DropdownButtonSearchFilter(
                onFilterChanged: (mode) {
                  searchQuery = '';
                  searchController.clear();
                  setFilterMode(mode);
                },
              ),
              ),
            ]),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Cocktail>>(
                key: futureBuilderKey,
            future: futureCocktails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  filterCocktails(snapshot.data!, searchQuery);

                  if (filteredCocktails.isEmpty) {
                    // Display "No cocktail found" when the list is empty
                    return const Center(
                      child: Text('No cocktail found'),
                    );
                  }

                  return ValueListenableBuilder<String>(
                      valueListenable: nearestIngredientNotifier,
                  builder: (context, value, child) {
                    return GridView.count(
                      crossAxisCount: 2,
                      children: filteredCocktails.map((cocktail) {
                        return Center(
                          child: CocktailListItem(
                              additionalInfo: getAdditionalInfo(cocktail),
                              cocktail: cocktail),
                        );
                      }).toList(),
                    );
                  });
                } else {
                  return const Text('No cocktails found');
                }
              },
            ),
            )
          ],
        ),
      ),
    );
  }
}
