import 'package:flutter/material.dart';
import './recipe.dart';
import './recipe_detail.dart';
import './recipe_search.dart'; // Import the recipe search file

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      ),
      home: const MyHomePage(title: 'Recipe Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Recipe> filteredRecipes = List.from(samples);
  int _selectedIndex = 0; // Index for selected bottom navigation item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final selectedRecipe = await showSearch(
                context: context,
                delegate: RecipeSearchDelegate(filteredRecipes),
              );
              if (selectedRecipe != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetail(recipe: selectedRecipe),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.home), // Home icon
            onPressed: () =>
                navigateToHomeScreen(context), // Navigate to home screen
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: filteredRecipes.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetail(recipe: filteredRecipes[index]),
                  ),
                );
              },
              child: buildRecipeCard(filteredRecipes[index]),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.breakfast_dining),
            label: 'Breakfast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lunch_dining),
            label: 'Lunch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dinner_dining),
            label: 'Dinner',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Filter recipes based on the selected category
      switch (index) {
        case 0:
          filteredRecipes = samples
              .where((recipe) => recipe.category == 'Breakfast')
              .toList();
          break;
        case 1:
          filteredRecipes =
              samples.where((recipe) => recipe.category == 'Lunch').toList();
          break;
        case 2:
          filteredRecipes =
              samples.where((recipe) => recipe.category == 'Dinner').toList();
          break;
        default:
          filteredRecipes = List.from(samples);
      }
    });
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'Recipe Application')),
    );
  }

  Widget buildRecipeCard(Recipe recipe) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(), // Loading indicator
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetail(recipe: recipe),
                      ),
                    );
                  },
                  child: Image(
                    image: AssetImage(recipe.imageUrl),
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Text('Image not found');
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child:
                              CircularProgressIndicator(), // Loading indicator
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            Text(
              recipe.label,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Palatino',
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Steps: ${recipe.procedures.length}',
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
