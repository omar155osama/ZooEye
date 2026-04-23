class Animal {
  final int id;
  final String arabicName;
  final String englishName;
  final String scientificName;
  final String category;
  final String habitat;
  final String diet;
  final String lifespan;
  final String weight;
  final String conservation;
  final String description;
  final String source; // 'zoo' or 'reserve'

  const Animal({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.scientificName,
    required this.category,
    required this.habitat,
    required this.diet,
    required this.lifespan,
    required this.weight,
    required this.conservation,
    required this.description,
    this.source = 'zoo',
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arabicName': arabicName,
      'englishName': englishName,
      'scientificName': scientificName,
      'category': category,
      'habitat': habitat,
      'diet': diet,
      'lifespan': lifespan,
      'weight': weight,
      'conservation': conservation,
      'description': description,
      'source': source,
    };
  }

  // Create from Map
  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id'] ?? 0,
      arabicName: map['arabicName'] ?? '',
      englishName: map['englishName'] ?? '',
      scientificName: map['scientificName'] ?? '',
      category: map['category'] ?? '',
      habitat: map['habitat'] ?? '',
      diet: map['diet'] ?? '',
      lifespan: map['lifespan'] ?? '',
      weight: map['weight'] ?? '',
      conservation: map['conservation'] ?? '',
      description: map['description'] ?? '',
      source: map['source'] ?? 'zoo',
    );
  }

  // Copy with
  Animal copyWith({
    int? id,
    String? arabicName,
    String? englishName,
    String? scientificName,
    String? category,
    String? habitat,
    String? diet,
    String? lifespan,
    String? weight,
    String? conservation,
    String? description,
    String? source,
  }) {
    return Animal(
      id: id ?? this.id,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      scientificName: scientificName ?? this.scientificName,
      category: category ?? this.category,
      habitat: habitat ?? this.habitat,
      diet: diet ?? this.diet,
      lifespan: lifespan ?? this.lifespan,
      weight: weight ?? this.weight,
      conservation: conservation ?? this.conservation,
      description: description ?? this.description,
      source: source ?? this.source,
    );
  }

  @override
  String toString() {
    return 'Animal(id: $id, name: $englishName, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Animal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
