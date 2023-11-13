import 'package:flutter/material.dart';

class CocktailPage extends StatefulWidget {
  final String cocktailName;

  const CocktailPage({super.key, required this.cocktailName});

  @override
  State<CocktailPage> createState() => _CocktailPageState();
}

class _CocktailPageState extends State<CocktailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktailName),
      ),
      body: Center(
        child: Text('Details for ${widget.cocktailName}'),
      ),
    );
  }
}
