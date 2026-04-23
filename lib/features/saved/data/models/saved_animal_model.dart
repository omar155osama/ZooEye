class SavedAnimalModel {
  final String id;
  final Map<String, dynamic> animal;
  final String imagePath;
  final DateTime savedAt;
  final bool isFromAI;
  
  SavedAnimalModel({
    required this.id,
    required this.animal,
    required this.imagePath,
    required this.savedAt,
    this.isFromAI = false,
  });
  
  factory SavedAnimalModel.fromJson(Map<String, dynamic> json) {
    return SavedAnimalModel(
      id: json['id'],
      animal: json['animal'] as Map<String, dynamic>,
      imagePath: json['imagePath'],
      savedAt: DateTime.parse(json['savedAt']),
      isFromAI: json['isFromAI'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal': animal,
      'imagePath': imagePath,
      'savedAt': savedAt.toIso8601String(),
      'isFromAI': isFromAI,
    };
  }
}