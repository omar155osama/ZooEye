import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../cubit/explore_cubit.dart';

class HomeScreen extends StatefulWidget {
  // 🌟 مسحنا الـ Callbacks من هنا لأن الـ Cubit هيقوم بالمهمة
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _scanController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scanAnimation;
  bool _isPressed = false;
  bool _isGalleryPressed = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('🦁', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ZooEye',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryGreen,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Camera Viewfinder (Card)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final viewfinderHeight = math.min(
                      constraints.maxHeight * 0.7,
                      360.0,
                    );
                    return Container(
                      height: viewfinderHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.3, -1),
                                  end: Alignment(-0.3, 1),
                                  colors: [
                                    AppColors.cameraBgStart,
                                    AppColors.cameraBgMiddle,
                                    AppColors.cameraBgEnd,
                                  ],
                                  stops: [0.0, 0.4, 1.0],
                                ),
                              ),
                            ),
                            Center(
                              child: AnimatedBuilder(
                                animation: _floatAnimation,
                                builder: (context, child) =>
                                    Transform.translate(
                                      offset: Offset(0, _floatAnimation.value),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '🦒',
                                            style: TextStyle(fontSize: 64),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'camera preview',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            ),
                            ..._buildCornerBrackets(),
                            AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, child) => Positioned(
                                left: 16,
                                right: 16,
                                top:
                                    20 +
                                    viewfinderHeight * _scanAnimation.value,
                                child: Container(
                                  height: 1.5,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.accentOrange,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accentOrange
                                            .withValues(alpha: 0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 🌟 Take Photo Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  // 🌟 استدعاء الكوبيت مباشرة
                  context.read<ExploreCubit>().pickImage(ImageSource.camera);
                },
                onTapCancel: () => setState(() => _isPressed = false),
                child: AnimatedScale(
                  scale: _isPressed ? 0.97 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryGreen,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF2D5016),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Take Photo',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 🌟 Gallery Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isGalleryPressed = true),
                onTapUp: (_) {
                  setState(() => _isGalleryPressed = false);
                  // 🌟 استدعاء الكوبيت مباشرة
                  context.read<ExploreCubit>().pickImage(ImageSource.gallery);
                },
                onTapCancel: () => setState(() => _isGalleryPressed = false),
                child: AnimatedScale(
                  scale: _isGalleryPressed ? 0.97 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Choose from Gallery',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const s = 24.0, o = 16.0, w = 2.5, c = AppColors.accentOrange;
    return [
      Positioned(
        top: o,
        left: o,
        child: Container(
          width: s,
          height: s,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: c, width: w),
              left: BorderSide(color: c, width: w),
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4)),
          ),
        ),
      ),
      Positioned(
        top: o,
        right: o,
        child: Container(
          width: s,
          height: s,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: c, width: w),
              right: BorderSide(color: c, width: w),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(4)),
          ),
        ),
      ),
      Positioned(
        bottom: o,
        left: o,
        child: Container(
          width: s,
          height: s,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: c, width: w),
              left: BorderSide(color: c, width: w),
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4)),
          ),
        ),
      ),
      Positioned(
        bottom: o,
        right: o,
        child: Container(
          width: s,
          height: s,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: c, width: w),
              right: BorderSide(color: c, width: w),
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(4)),
          ),
        ),
      ),
    ];
  }
}
