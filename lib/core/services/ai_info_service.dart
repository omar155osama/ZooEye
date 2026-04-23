import 'dart:convert';
import 'dart:async'; // 🌟 مهم عشان الـ TimeoutException
import 'package:http/http.dart' as http;

class AIInfoService {
  static const String apiKey = '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';
  static const String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String model = 'openrouter/auto';

  static Future<Map<String, dynamic>> getAnimalInfo(String animalName) async {
    try {
      final prompt = '''
Strictly analyze: "$animalName".
RULES:
1. If the object is a HUMAN, PERSON, or NOT AN ANIMAL, you MUST return ONLY: {"error": "not_an_animal"}
2. DO NOT provide info for people, humans, or inanimate objects.
3. For "conservation", use maximum 2 words (e.g., "غير مهدد").
4. Return ONLY valid JSON:
{
  "arabicName": "الاسم",
  "englishName": "Name",
  "scientificName": "Scientific",
  "category": "الفئة",
  "description": "3 short sentences in Arabic",
  "habitat": "الموطن",
  "diet": "الغذاء",
  "lifespan": "العمر",
  "weight": "الوزن",
  "conservation": "كلمتين فقط"
}
''';

      // 🌟 إضافة Timeout لمدة 20 ثانية
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 800,
        }),
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw Exception('السيرفر استغرق وقتاً طويلاً. تأكد من جودة الإنترنت أو حاول لاحقاً.');
      });


      // 🌟 معالجة الردود
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var content = data['choices'][0]['message']['content'].toString().trim();

        content = content.replaceAll('```json', '').replaceAll('```', '').trim();

        try {
          return jsonDecode(content);
        } catch (e) {
          throw Exception('الذكاء الاصطناعي أرجع بيانات غير مفهومة. حاول مرة أخرى.');
        }
      } else if (response.statusCode == 429 || response.statusCode == 402) {
        throw Exception('الضغط عالي على الخادم أو تم تجاوز الحد المسموح.');
      } else {
        throw Exception('AI API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('فشل الحصول على المعلومات: $e');
    }
  }
}