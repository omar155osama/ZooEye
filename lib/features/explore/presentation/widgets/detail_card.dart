import 'package:flutter/material.dart';
import 'package:zooeye/core/constants/app_colors.dart';

class DetailCard extends StatelessWidget {
  final String icon;
  final String label;
  final String labelAr;
  final String content;

  const DetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.labelAr,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // 🌟 قللنا المسافة بين الكروت
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.navBarBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14), // 🌟 حواف ألم شوية
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ), // 🌟 قللنا المسافات الداخلية
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الأيقونة
            Container(
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                icon,
                style: const TextStyle(fontSize: 16),
              ), // 🌟 أيقونة أصغر
            ),
            const SizedBox(width: 12),

            // النصوص (العنوان والمحتوى)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان الإنجليزي والعربي جنب بعض عشان نوفر مساحة
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        labelAr,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Cairo',
                          color: AppColors.primaryGreen.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // 🌟 مسافة صغيرة جداً قبل المحتوى
                  // المحتوى
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14, // 🌟 خط أصغر سيكا وملموم
                      color: Color(0xFF333333),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
