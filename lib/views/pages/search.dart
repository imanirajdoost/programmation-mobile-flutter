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
  final TextEditingController searchController = TextEditingController();

  String filterMode = 'Name'; // Variable to store the current filter mod

  void setFilterMode(String mode) {
    setState(() {
      filterMode = mode;
    });
  }

  @override
  void initState() {
    super.initState();
    futureCocktails = getCocktailsFromStorage();
  }

  List<Cocktail> filterCocktails(List<Cocktail> cocktails, String query) {
    if (query.isEmpty) {
      return cocktails;
    } else {
      if (filterMode == 'Name') {
        return cocktails.where((cocktail) => cocktail.name.toLowerCase().contains(query.toLowerCase())).toList();
      } else { // 'Ingredient' filter mode
        return cocktails.where((cocktail) =>
            cocktail.ingredients.any((ingredient) => ingredient.toLowerCase().contains(query.toLowerCase()))
        ).toList();
      }
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
        });
      },
    );


    // Search field and button
    final searchFieldAndButton = Row(
      children: [
        Expanded(child: searchField),
      ],
    );

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
                  setFilterMode(mode);
                },
              ),
              ),
            ]),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Cocktail>>(
            future: futureCocktails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Cocktail> filteredCocktails =
                  filterCocktails(snapshot.data!, searchQuery);

                  if (filteredCocktails.isEmpty) {
                    // Display "No cocktail found" when the list is empty
                    return const Center(
                      child: Text('No cocktail found'),
                    );
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    children: filteredCocktails.map((cocktail) {
                      return Center(
                        child: CocktailListItem(cocktail: cocktail),
                      );
                    }).toList(),
                  );
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
