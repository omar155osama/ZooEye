import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChange;

  const BottomNavBar({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            // 🌟 استخدام اللون الكريمي الجديد بدلاً من الأبيض
            color: AppColors.navBarBg,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                // 🌟 استخدام withValues للشفافية
                color: AppColors.primaryGreen.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabItem(
                id: 'home',
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                isActive: activeTab == 'home',
              ),
              _buildTabItem(
                id: 'search',
                icon: Icons.menu_book_rounded,
                label: 'Search',
                isActive: activeTab == 'search',
              ),
              _buildTabItem(
                id: 'quiz',
                icon: Icons.extension_rounded,
                label: 'Quiz',
                isActive: activeTab == 'quiz',
              ),
              _buildTabItem(
                id: 'saved',
                icon: Icons.bookmark_rounded,
                label: 'Saved',
                isActive: activeTab == 'saved',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String id,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTabChange(id),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // خلفية التبويب المفعل تأخذ الأخضر الأساسي بشرط شفافية خفيف
          color: isActive
              ? AppColors.primaryGreen.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              // تبديل اللون بين الأخضر والدرجة الشفافة
              color: isActive
                  ? AppColors.primaryGreen
                  : AppColors.primaryGreen.withValues(alpha: 0.4),
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
