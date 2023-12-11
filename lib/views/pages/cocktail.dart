import 'package:flutter/material.dart';
import 'package:projetprogmobile/models/cocktails.dart';
import 'package:projetprogmobile/storage/cocktails.dart';
import 'package:share/share.dart';

class CocktailPage extends StatefulWidget {
  final Cocktail cocktail;
  final Function(bool) onLikeChanged; // Add this callback

  const CocktailPage(
      {super.key, required this.cocktail, required this.onLikeChanged});

  @override
  State<CocktailPage> createState() => _CocktailPageState();
}

class _CocktailPageState extends State<CocktailPage> {
  bool isLiked = false; // Variable to track if the cocktail is liked

  @override
  void initState() {
    super.initState();
    _loadIsLiked();

    print('Alcoholic: ${widget.cocktail.alcoholic}');
    print('Glass: ${widget.cocktail.glass}');
    print('Instructions: ${widget.cocktail.instructions}');
    print('Ingredients: ${widget.cocktail.ingredients}');
    print('Measures: ${widget.cocktail.measures}');
    print('Tags: ${widget.cocktail.tags}');
    print('Category: ${widget.cocktail.category}');
    print('IBA: ${widget.cocktail.IBA}');
  }

  void _loadIsLiked() async {
    String? likedCocktail = await getLikedCocktailFromCache(widget.cocktail.id);
    setState(() {
      isLiked = likedCocktail != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Stack(
        alignment: Alignment.bottomRight,
          children: [
            Image.network(widget.cocktail.thumbnailURL),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    icon: Icons.share,
                    color: Colors.white,
                    onPressed: () => Share.share(createShareContent()),
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  _buildActionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                        if (isLiked) {
                          saveLikedCocktail(widget.cocktail.id);
                        } else {
                          removeLikedCocktail(widget.cocktail.id);
                        }
                      });
                      widget.onLikeChanged(isLiked);
                    },
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  ],
                ),
            ),
              ],
            ),
            const SizedBox(height: 8),
            _detailCard('Name', widget.cocktail.name),
            if (widget.cocktail.alcoholic != null)
              _detailCard('Alcoholic', widget.cocktail.alcoholic ?? ""),
            if (widget.cocktail.glass != null)
              _detailCard('Glass', widget.cocktail.glass ?? ""),
            if (widget.cocktail.tags.isNotEmpty &&
                widget.cocktail.tags[0] != null &&
                widget.cocktail.tags[0] != '')
              _detailCard('Tags', widget.cocktail.tags.join(', ')),
            // if (widget.cocktail.IBA != null)
            //   _detailCard('IBA', widget.cocktail.IBA!),
            if (widget.cocktail.category != null)
              _detailCard('Category', widget.cocktail.category ?? ""),
            _detailCard('Ingredients', _ingredientsText()),
            _detailCard('Instructions', widget.cocktail.instructions ?? ""),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(content),
      ),
    );
  }

  String _ingredientsText() {
    int listLength = widget.cocktail.ingredients.length;
    if (widget.cocktail.measures.length < listLength) {
      listLength = widget.cocktail.measures.length;
    }
    return widget.cocktail.ingredients
        .asMap()
        .entries
        .map((entry) =>
            "${entry.value} - ${widget.cocktail.measures.length > entry.key ? widget.cocktail.measures[entry.key] : 'N/A'}")
        .join('\n');
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }

  String createShareContent() {
    String ingredientsText = widget.cocktail.ingredients
        .asMap()
        .entries
        .map((entry) =>
    "${entry.value} - ${widget.cocktail.measures.length > entry.key ? widget.cocktail.measures[entry.key] : 'N/A'}")
        .join('\n');

    return "Checkout this cocktail: ${widget.cocktail.name}\n\nImage: ${widget.cocktail.thumbnailURL}\n\nIt is made using these ingredients:\n$ingredientsText\n\nInstructions:\n${widget.cocktail.instructions}";
  }

}
