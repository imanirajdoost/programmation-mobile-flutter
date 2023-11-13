import 'package:flutter/material.dart';

class CocktailItem extends StatefulWidget {
  final String title;

  const CocktailItem({super.key, required this.title});

  @override
  State<CocktailItem> createState() => _CocktailItemState();
}

class _CocktailItemState extends State<CocktailItem> {
  late String name;

  @override
  void initState() {
    super.initState();
    name = widget.title; // Initialize name here
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}