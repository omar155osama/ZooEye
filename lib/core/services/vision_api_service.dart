import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class VisionApiService {
  static const String apiKey =
      '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';
  static const String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String model = 'openrouter/auto';

  static Future<String> analyzeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 🌟 إضافة Timeout لمدة 20 ثانية
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
              'HTTP-Referer': 'https://zooeye-app.com',
              'X-Title': 'ZooEye App',
            },
            body: jsonEncode({
              'model': model,
              'messages': [
                {
                  'role': 'user',
                  'content': [
                    {
                      'type': 'text',
                      'text':
                          '''Identify the most prominent animal or bird in this image. 
                  Rules:
                  1. Respond with ONLY the specific common English name (e.g., "Laughing Dove", "Pigeon", "Lion").
                  2. DO NOT use generic terms like "Bird", "Animal", or "Fish". Be specific.
                  3. If there are multiple animals, identify the one in the center or the largest one.
                  4. If the image is a HUMAN, a TOY, a CARTOON, or NOT an animal/bird, respond exactly with: "not_an_animal".''',
                    },
                    {
                      'type': 'image_url',
                      'image_url': {
                        'url': 'data:image/jpeg;base64,$base64Image',
                      },
                    },
                  ],
                },
              ],
              'max_tokens': 50,
            }),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw Exception(
                'السيرفر استغرق وقتاً طويلاً. تأكد من جودة الإنترنت أو حاول لاحقاً.',
              );
            },
          );

      // 🌟 معالجة الردود بشكل آمن
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['choices'][0]['message']['content']
            .toString()
            .trim();
        return result.replaceAll('*', '').replaceAll('`', '');
      } else if (response.statusCode == 429 || response.statusCode == 402) {
        throw Exception(
          'الضغط عالي على الخادم حالياً. يرجى المحاولة بعد قليل.',
        );
      } else {
        throw Exception(
          'فشل في الاتصال بخدمة التعرف على الصور (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء تحليل الصورة: $e');
    }
  }
}
