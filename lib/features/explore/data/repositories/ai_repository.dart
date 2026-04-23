import 'dart:io';

import 'package:zooeye/core/services/ai_info_service.dart';
import 'package:zooeye/core/services/vision_api_service.dart';


class AIRepository {
  /// تحليل صورة حيوان
  Future<String> analyzeImage(File imageFile) async {
    return await VisionApiService.analyzeImage(imageFile);
  }
  
  /// جلب معلومات حيوان من AI
  Future<Map<String, dynamic>> getAnimalInfo(String animalName) async {
    return await AIInfoService.getAnimalInfo(animalName);
  }
}