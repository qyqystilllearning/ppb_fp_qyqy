import 'package:isar/isar.dart';

part 'ingredient.g.dart'; // This is required for Isar to generate the background code!

@collection
class Ingredient {
  Id id = Isar.autoIncrement; // Auto-generates a unique ID (1, 2, 3...)

  late String name; // e.g., "Flour", "Eggs", "Milk"
}
