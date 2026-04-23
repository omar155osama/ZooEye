import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zooeye/core/constants/app_colors.dart';

class DetailHeroWidget extends StatelessWidget {
  final Map<String, dynamic> animal;
  final File capturedImage;
  final VoidCallback onBack;

  const DetailHeroWidget({
    super.key,
    required this.animal,
    required this.capturedImage,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // 1. الصورة
          Positioned.fill(child: Image.file(capturedImage, fit: BoxFit.cover)),
          
          // 2. التدرج اللوني (عشان النص يبان بوضوح)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
          ),
          
          // 3. زر الرجوع
          Positioned(
            top: 56, left: 16,
            child: _buildCircleButton(icon: Icons.arrow_back, onTap: onBack),
          ),
          
          // 4. النصوص (اسم الحيوان)
          Positioned(
            bottom: 16, left: 20, right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal['englishName'] ?? '',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2),
                ),
                if (animal['arabicName'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      animal['arabicName'],
                      style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8)),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
        child: Center(child: Icon(icon, color: AppColors.navBarBg)),
      ),
    );
  }
}