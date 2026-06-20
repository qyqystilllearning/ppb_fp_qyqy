import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// We must import our two models so Isar knows what to load
import '../models/ingredient.dart';
import '../models/recipe.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // 1. OPENING THE DATABASE
  Future<Isar> openDB() async {
    // If no instance is open, open one in the app's document folder
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [IngredientSchema, RecipeSchema], // We give it both schemas!
        directory: dir.path,
        inspector: true, // Allows us to use the Isar Inspector tool on browser
      );
    }
    // If one is already open, just return it
    return Future.value(Isar.getInstance());
  }

  // ------------------------------------
  // --- INGREDIENT FUNCTIONS ---
  // ------------------------------------
  
  Future<void> saveIngredient(Ingredient newIngredient) async {
    final isar = await db;
    // writeTxn is required anytime we MODIFY the database (Create, Update, Delete)
    await isar.writeTxn(() async {
      await isar.ingredients.put(newIngredient);
    });
  }

  // We need this so the UI can fetch and display all ingredients
  Future<List<Ingredient>> getAllIngredients() async {
    final isar = await db;
    return await isar.ingredients.where().findAll();
  }

  // ------------------------------------
  // --- RECIPE FUNCTIONS (MANY TO MANY) ---
  // ------------------------------------
  
  // This is where the Many-to-Many magic actually happens!
  // Notice we take BOTH the new recipe, AND a list of the ingredients the user selected.
  Future<void> saveRecipe(Recipe newRecipe, List<Ingredient> selectedIngredients) async {
    final isar = await db;
    
    await isar.writeTxn(() async {
      // Step 1: First, we must save the Recipe to the database to generate an ID for it.
      await isar.recipes.put(newRecipe);
      
      // Step 2: Now we add the list of ingredients to the recipe's IsarLinks.
      newRecipe.ingredients.addAll(selectedIngredients);
      
      // Step 3: Finally, we tell Isar to save the links to the background bridge table!
      await newRecipe.ingredients.save();
    });
  }

  Future<List<Recipe>> getAllRecipes() async {
    final isar = await db;
    return await isar.recipes.where().findAll();
  }
}
