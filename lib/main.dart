import 'package:flutter/material.dart';
import 'services/isar_service.dart';
import 'models/ingredient.dart';
import 'models/recipe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // We create one instance of our IsarService to pass to the app
  final IsarService isarService = IsarService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipeBookHome(isarService: isarService),
    );
  }
}

class RecipeBookHome extends StatefulWidget {
  final IsarService isarService;

  RecipeBookHome({required this.isarService});

  @override
  _RecipeBookHomeState createState() => _RecipeBookHomeState();
}

class _RecipeBookHomeState extends State<RecipeBookHome> {
  // To handle switching between the two tabs
  int _currentIndex = 0;

  // Controllers for our text input boxes
  final _ingredientController = TextEditingController();
  final _recipeController = TextEditingController();

  // State variables to hold data downloaded from the database
  List<Ingredient> _pantry = [];
  List<Recipe> _recipes = [];
  
  // A temporary list to keep track of which checkboxes are ticked!
  List<Ingredient> _selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fetch all ingredients and recipes from the database
  void _loadData() async {
    final ingredients = await widget.isarService.getAllIngredients();
    final recipes = await widget.isarService.getAllRecipes();
    setState(() {
      _pantry = ingredients;
      _recipes = recipes;
    });
  }

  // --- DATABASE ACTIONS ---
  
  void _addIngredient() async {
    if (_ingredientController.text.isEmpty) return;
    
    // Create a new Ingredient object
    final newIngredient = Ingredient()..name = _ingredientController.text;
    
    // Save it to the database
    await widget.isarService.saveIngredient(newIngredient);
    
    _ingredientController.clear();
    _loadData(); // Refresh the screen
  }

  void _saveRecipe() async {
    if (_recipeController.text.isEmpty || _selectedIngredients.isEmpty) return;

    // Create a new Recipe object
    final newRecipe = Recipe()..title = _recipeController.text;
    
    // Call our magical Many-to-Many service method!
    await widget.isarService.saveRecipe(newRecipe, _selectedIngredients);

    _recipeController.clear();
    setState(() {
      _selectedIngredients.clear(); // Reset the checkboxes
    });
    _loadData(); // Refresh the screen
  }

  // --- UI SCREENS ---

  Widget _buildPantryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Add raw ingredients to your pantry!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ingredientController,
                  decoration: InputDecoration(hintText: "e.g., Flour, Eggs, Sugar"),
                ),
              ),
              IconButton(icon: Icon(Icons.add_circle, color: Colors.blue, size: 40), onPressed: _addIngredient),
            ],
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _pantry.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.kitchen),
                    title: Text(_pantry[index].name),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecipesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _recipeController,
            decoration: InputDecoration(hintText: "Recipe Name (e.g., Pancakes)", labelText: "Create a new Recipe"),
          ),
          SizedBox(height: 10),
          Text("Select Ingredients Required:", style: TextStyle(fontWeight: FontWeight.bold)),
          
          // A mini scrollable box for checkboxes
          Container(
            height: 150,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
            child: ListView.builder(
              itemCount: _pantry.length,
              itemBuilder: (context, index) {
                final ingredient = _pantry[index];
                return CheckboxListTile(
                  title: Text(ingredient.name),
                  value: _selectedIngredients.contains(ingredient), // Is it checked?
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedIngredients.add(ingredient);
                      } else {
                        _selectedIngredients.remove(ingredient);
                      }
                    });
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _saveRecipe,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[300]),
            child: Text("Save Recipe", style: TextStyle(color: Colors.black)),
          ),
          Divider(),
          Text("Your Saved Recipes:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                
                // IMPORTANT: We must call .loadSync() to actually pull the linked ingredients from the database!
                recipe.ingredients.loadSync(); 
                
                // Map the ingredient objects into a single string like "Flour, Eggs, Sugar"
                final ingredientNames = recipe.ingredients.map((i) => i.name).join(", ");
                
                return Card(
                  color: Colors.orange[50],
                  child: ListTile(
                    title: Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Requires: $ingredientNames"),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Isar Recipe Book"),
        backgroundColor: Colors.orange[300],
      ),
      // Switch between the two tabs depending on what is clicked on the bottom bar
      body: _currentIndex == 0 ? _buildPantryTab() : _buildRecipesTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: "Pantry"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Recipes"),
        ],
      ),
    );
  }
}