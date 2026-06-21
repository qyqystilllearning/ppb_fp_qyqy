import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/isar_service.dart';
import 'services/firestore_service.dart';
import 'models/ingredient.dart';
import 'models/recipe.dart';
import 'screens/login.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await NotificationService.initializeNotification();

  runApp(MyApp());
}

class AuthWrapper extends StatelessWidget {
  final IsarService isarService;
  final FirestoreService firestoreService;

  const AuthWrapper({required this.isarService, required this.firestoreService, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // If the user is logged in, show the Recipe Book
        if (snapshot.hasData) {
          return RecipeBookHome(
            isarService: isarService,
            firestoreService: firestoreService,
          );
        } else {
          // If NOT logged in, show the Login Screen
          return const LoginScreen();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // We create one instance of our IsarService to pass to the app
  final IsarService isarService = IsarService();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(
        isarService: isarService,
        firestoreService: firestoreService,
      ),
    );
  }
}

class RecipeBookHome extends StatefulWidget {
  final IsarService isarService;
  final FirestoreService firestoreService;

  RecipeBookHome({required this.isarService, required this.firestoreService});

  @override
  _RecipeBookHomeState createState() => _RecipeBookHomeState();
}

class _RecipeBookHomeState extends State<RecipeBookHome> {
  // To handle switching between the two tabs
  int _currentIndex = 0;

  // Controllers for our text input boxes
  final _ingredientController = TextEditingController();
  final _recipeController = TextEditingController();
  final _cloudNoteController = TextEditingController();

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

  // --- CLOUD DATABASE ACTIONS ---
  void _addCloudNote() async {
    if (_cloudNoteController.text.isEmpty) return;
    await widget.firestoreService.addNote(_cloudNoteController.text);
    _cloudNoteController.clear();
    // We don't need _loadData() here because the StreamBuilder automatically updates the UI!
  }

  // --- UI SCREENS ---

  Widget _buildCloudNotesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Save a note directly to Firebase Cloud!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cloudNoteController,
                  decoration: InputDecoration(hintText: "Type a cloud note here..."),
                ),
              ),
              IconButton(icon: Icon(Icons.cloud_upload, color: Colors.blue, size: 40), onPressed: _addCloudNote),
            ],
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.firestoreService.getNotesStream(),
              builder: (context, snapshot) {
                // If it's loading data from the internet
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                // If there's an error
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // If we have data!
                final notes = snapshot.data?.docs ?? [];
                
                if (notes.isEmpty) {
                  return Center(child: Text("No cloud notes yet!"));
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final noteData = notes[index].data() as Map<String, dynamic>;
                    return Card(
                      color: Colors.blue[50],
                      child: ListTile(
                        leading: Icon(Icons.cloud, color: Colors.blue),
                        title: Text(noteData['text'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

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
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 1,
                title: 'Cooking Timer',
                body: 'Beep beep! Your food is ready!',
                scheduled: false, // Changed to instant to test!
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Instant notification triggered!')));
              }
            },
            child: const Text('Test Instant Notification'),
          ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      // Switch between the THREE tabs depending on what is clicked on the bottom bar
      body: _currentIndex == 0 
          ? _buildPantryTab() 
          : _currentIndex == 1 
              ? _buildRecipesTab() 
              : _buildCloudNotesTab(),
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
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Cloud"),
        ],
      ),
    );
  }
}