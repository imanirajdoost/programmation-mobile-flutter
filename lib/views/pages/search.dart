import 'package:flutter/material.dart';
import 'package:projetprogmobile/views/search_dropdown_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {

    // Text field with search icon
    final searchField = TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
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
            const Row(
              children: [
                Expanded(child: DropdownButtonSearchFilter()
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}
