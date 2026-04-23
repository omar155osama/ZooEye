import 'package:zooeye/features/explore/data/models/animal_database.dart';

class AnimalRepository {
  /// Smart match - returns animal from database or null
  static Map<String, dynamic>? smartMatch(String query) {
    final animal = AnimalDatabase.smartMatch(query);

    if (animal != null) {
      return {
        'arabicName': animal.arabicName,
        'englishName': animal.englishName,
        'scientificName': animal.scientificName,
        'category': animal.category,
        'habitat': animal.habitat,
        'diet': animal.diet,
        'lifespan': animal.lifespan,
        'weight': animal.weight,
        'conservation': animal.conservation,
        'description': animal.description,
        'source': animal.source,
      };
    }

    return null;
  }

  /// Get animal by ID
  static Map<String, dynamic>? getById(int id) {
    final animal = AnimalDatabase.getAnimalById(id);

    if (animal != null) {
      return animal.toMap();
    }

    return null;
  }

  /// Get all animals
  static List<Map<String, dynamic>> getAllAnimals() {
    return AnimalDatabase.getAllAnimals()
        .map((animal) => animal.toMap())
        .toList();
  }

  /// Search by category
  static List<Map<String, dynamic>> searchByCategory(String category) {
    return AnimalDatabase.searchByCategory(
      category,
    ).map((animal) => animal.toMap()).toList();
  }

  /// Search by conservation status
  static List<Map<String, dynamic>> searchByConservation(String status) {
    return AnimalDatabase.searchByConservation(
      status,
    ).map((animal) => animal.toMap()).toList();
  }

  /// Get total count
  static int getTotalCount() {
    return AnimalDatabase.getTotalCount();
  }

  /// Get all categories
  static List<String> getCategories() {
    return AnimalDatabase.getCategories();
  }

  /// Advanced search - searches across all fields
  static List<Map<String, dynamic>> advancedSearch(String query) {
    if (query.isEmpty) return [];

    final allAnimals = AnimalDatabase.getAllAnimals();
    final normalizedQuery = query.toLowerCase().trim();

    return allAnimals
        .where((animal) {
          final searchableText =
              '''
        ${animal.englishName}
        ${animal.arabicName}
        ${animal.scientificName}
        ${animal.category}
        ${animal.habitat}
        ${animal.description}
      '''
                  .toLowerCase();

          return searchableText.contains(normalizedQuery);
        })
        .map((animal) => animal.toMap())
        .toList();
  }
}
