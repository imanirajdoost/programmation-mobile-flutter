import 'package:flutter/material.dart';
import 'package:projetprogmobile/http/cocktails.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/views/cocktail_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Cocktail>> futureCocktails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cocktails'),
        ),
        body: Center(
          child: FutureBuilder<List<Cocktail>>(
            future: futureCocktails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(crossAxisCount: 2,
                  children: snapshot.data!.map((e) => Center(
                    child: CocktailListItem(cocktail: e),
                  ),
                ).toList());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    futureCocktails = fetchCocktails();
  }
}