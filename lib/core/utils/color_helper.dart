import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ColorHelper {
  static Color getStatusColor(String? status) {
    if (status == null) return AppColors.primaryGreen;

    final lower = status.toLowerCase().replaceAll(RegExp(r'[\u064B-\u065F]'), '').trim();

    if (lower.contains('endangered') ||
        lower.contains('extinct') ||
        lower.contains('مهدد') ||
        lower.contains('انقراض') ||
        lower.contains('حرج')) {
      return const Color(0xFFD9534F);
    } else if (lower.contains('vulnerable') ||
        lower.contains('threatened') ||
        lower.contains('خطر') ||
        lower.contains('عرضة') ||
        lower.contains('عرضه') ||
        lower.contains('للخطر') ||
        status.contains('ﻋُرﺿﺔ') ||
        status.contains('ﻋرﺿﺔ') ||
        status.contains('ﻟﻠﺧطر')) {
      return AppColors.accentOrange;
    }

    return AppColors.primaryGreen;
  }
}