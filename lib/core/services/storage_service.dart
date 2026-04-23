import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const String _savedKey = 'saved_animals';
  
  /// حفظ حيوان
  static Future<bool> saveAnimal({
    required Map<String, dynamic> animal,
    required File imageFile,
    bool isFromAI = false,
  }) async {
    try {
      // 🌟 فحص التكرار قبل الحفظ
      final isAlreadySaved = await isAnimalSaved(animal['englishName']);
      if (isAlreadySaved) {
        return true; 
      }

      // حفظ الصورة
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/saved_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImagePath = '${imagesDir.path}/$fileName';
      await imageFile.copy(savedImagePath);
      
      // إنشاء saved object
      final savedAnimal = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'animal': animal,
        'imagePath': savedImagePath,
        'savedAt': DateTime.now().toIso8601String(),
        'isFromAI': isFromAI,
      };
      
      
      // حفظ في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final saved = await getSavedAnimals();
      saved.add(savedAnimal);
      
      await prefs.setString(_savedKey, jsonEncode(saved));

      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// جلب الحيوانات المحفوظة
  static Future<List<Map<String, dynamic>>> getSavedAnimals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_savedKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }
  
  /// حذف حيوان
  static Future<bool> deleteAnimal(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = await getSavedAnimals();
      
      // العثور على الحيوان لحذف صورته من الذاكرة
      final animal = saved.firstWhere((a) => a['id'] == id);
      final imageFile = File(animal['imagePath']);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      
      // حذف من القائمة
      saved.removeWhere((a) => a['id'] == id);
      
      await prefs.setString(_savedKey, jsonEncode(saved));
      
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// تحقق إذا كان محفوظ
  static Future<bool> isAnimalSaved(String englishName) async {
    final saved = await getSavedAnimals();
    return saved.any((a) => a['animal']['englishName'] == englishName);
  }
}