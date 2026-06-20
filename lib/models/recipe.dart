import 'package:isar/isar.dart';
import 'ingredient.dart'; // We must import the Ingredient file

part 'recipe.g.dart';

@collection
class Recipe {
  Id id = Isar.autoIncrement; // Auto-generates a unique ID

  late String title; // e.g., "Pancakes", "Omelet"

  // THIS IS THE MAGIC LINE!
  // IsarLinks creates a Many-to-Many bridge table automatically.
  // This says: "This recipe can hold a list of many Ingredients!"
  final ingredients = IsarLinks<Ingredient>();
}
