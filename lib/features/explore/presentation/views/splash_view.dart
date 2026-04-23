import 'package:flutter/material.dart';
import 'dart:async';
import 'main_app_screen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _taglineController;
  late Animation<double> _taglineOpacity;
  late Animation<double> _taglineTranslate;
  
  double _overallOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _taglineTranslate = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    // بدء أنيميشن النصوص بعد ظهور اللوجو
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _taglineController.forward();
    });

    // بدء الاختفاء التدريجي قبل الانتقال
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() => _overallOpacity = 0.0);
      }
    });

    // الانتقال للشاشة الرئيسية
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainAppScreen(),
            transitionsBuilder: (_, animation, __, child) => 
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 600), 
        opacity: _overallOpacity,
        child: Stack(
          children: [
            // خلفية الجراديانت الاحترافية
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A3A0A), 
                    Color(0xFF2D5016), 
                    Color(0xFF0D1A06)
                  ],
                ),
              ),
            ),

            // تأثير الهالة المضيئة خلف اللوجو
            Center(
              child: Container(
                width: 320, height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha:  0.08), 
                      Colors.transparent
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🌟 اللوجو الجديد مع Hero للتنقل الناعم
                  Hero(
                    tag: 'logo',
                    child: Container(
                      width: 140, // حجم اللوجو الجديد
                      height: 140,
                      padding: const EdgeInsets.all(10), // مساحة بيضاء خفيفة حول اللوجو
                      decoration: BoxDecoration(
                        color: Colors.white.withValues (alpha:  0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha:  0.1), 
                          width: 1
                        ),
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // اسم التطبيق
                  const Text(
                    'ZooEye',
                    style: TextStyle(
                      fontSize: 48, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.white, 
                      fontFamily: 'Cairo', 
                      letterSpacing: -1,
                    ),
                  ),
                  
                  // خط فاصل ذهبي صغير
                  const SizedBox(height: 8),
                  Container(
                    width: 50, 
                    height: 2.5, 
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8C07D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // أنيميشن النصوص (التاجلاين)
                  AnimatedBuilder(
                    animation: _taglineController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _taglineOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _taglineTranslate.value),
                          child: Column(
                            children: [
                              const Text(
                                'Discover the animal kingdom',
                                style: TextStyle(
                                  color: Color(0xFFE8C07D), 
                                  fontSize: 16, 
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'اكتشف عالم الحيوانات',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha:  0.3), 
                                  fontSize: 14, 
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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