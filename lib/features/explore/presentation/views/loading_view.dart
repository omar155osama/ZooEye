import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const LoadingScreen({
    super.key,
    required this.onComplete,
    File? previewImage,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  int _step = 0;

  // نصوص التحميل من كود الـ React الأصلي
  final List<Map<String, String>> _steps = [
    {'en': 'Looking at the animal…', 'ar': 'نتأمل الحيوان…'},
    {'en': 'Getting to know it…', 'ar': 'نتعرف عليه…'},
    {'en': 'Almost there!', 'ar': '!اكاد انتهي'},
  ];

  late AnimationController _floatController;
  late List<AnimationController> _dotControllers;

  @override
  void initState() {
    super.initState();

    // 🌟 أنيميشن "الطفو" للكارت (2.5s)
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    // 🌟 أنيميشن الـ 3 نقط (بفوارق زمنية 0.15s)
    _dotControllers = List.generate(
      3,
      (i) => AnimationController(
        duration: Duration(milliseconds: 700 + (i * 150)),
        vsync: this,
      ),
    );

    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _dotControllers[i].repeat(reverse: true);
      });
    }

    // ⏳ تغيير النصوص والتحويل التلقائي (نفس توقيتات React)
    // تغيير النصوص والتحويل التلقائي
    Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _step = 1);
    });

    Timer(const Duration(milliseconds: 2800), () {
      if (mounted) setState(() => _step = 2);
    });
    Timer(const Duration(milliseconds: 4000), widget.onComplete);
  }

  @override
  void dispose() {
    _floatController.dispose();
    for (var c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F0), // لون الخلفية الفاتح
      body: Stack(
        children: [
          // 🌟 Soft blobs في الخلفية (أخضر وبرتقالي شفاف جداً)
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withValues(
                  alpha: 0.04,
                ), // 8% opacity كما في الكود
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentOrange.withValues(alpha: 0.04),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌟 Animal card مع أنيميشن الطفو
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -10 * _floatController.value),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF8B6914),
                            Color(0xFFD4A820),
                            Color(0xFFA07010),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 48,
                            offset: const Offset(0, 16),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🦁', style: TextStyle(fontSize: 80)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // 🌟 النقط الثلاثة بتنط (Bouncing dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => AnimatedBuilder(
                      animation: _dotControllers[i],
                      builder: (context, child) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: [
                            AppColors.primaryGreen,
                            AppColors.accentOrange,
                            const Color(0xFFE8C07D),
                          ][i],
                        ),
                        transform: Matrix4.translationValues(
                          0,
                          -6 * _dotControllers[i].value,
                          0,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🌟 النصوص المتحركة (English & Arabic)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _steps[_step]['en']!,
                          key: ValueKey(_step),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _steps[_step]['ar']!,
                          key: ValueKey('ar$_step'),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
