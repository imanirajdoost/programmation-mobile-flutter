import 'package:flutter/material.dart';
import 'package:projetprogmobile/http/cocktails.dart';
import 'package:projetprogmobile/models/cocktails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Cocktail>> futureCocktails;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Cocktails'),
        ),
        body: Center(
          child: FutureBuilder<List<Cocktail>>(
            future: futureCocktails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.map((elem) => elem.name).join(", "));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
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