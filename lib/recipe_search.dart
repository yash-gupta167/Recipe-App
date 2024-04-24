import 'package:flutter/material.dart';
import './recipe.dart';

class RecipeSearchDelegate extends SearchDelegate<Recipe> {
  final List<Recipe> recipes;

  RecipeSearchDelegate(this.recipes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          close(context, null as Recipe);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = recipes
        .where((recipe) =>
            recipe.label.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results[index].label),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = recipes
        .where((recipe) =>
            recipe.label.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results[index].label),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
}
