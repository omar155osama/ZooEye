import 'dart:io';
import 'package:zooeye/core/services/storage_service.dart';
import '../models/saved_animal_model.dart';

class SavedRepository {
  /// حفظ حيوان
  Future<bool> saveAnimal({
    required Map<String, dynamic> animal,
    required File imageFile,
    bool isFromAI = false,
  }) async {
    return await StorageService.saveAnimal(
      animal: animal,
      imageFile: imageFile,
      isFromAI: isFromAI,
    );
  }
  
  /// جلب الحيوانات المحفوظة
  Future<List<SavedAnimalModel>> getSavedAnimals() async {
    final saved = await StorageService.getSavedAnimals();
    return saved.map((json) => SavedAnimalModel.fromJson(json)).toList();
  }
  
  /// حذف حيوان
  Future<bool> deleteAnimal(String id) async {
    return await StorageService.deleteAnimal(id);
  }
  
  /// تحقق إذا كان محفوظ
  Future<bool> isAnimalSaved(String englishName) async {
    return await StorageService.isAnimalSaved(englishName);
  }
}