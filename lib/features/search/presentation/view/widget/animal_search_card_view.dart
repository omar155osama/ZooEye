import 'package:flutter/material.dart';
import 'package:zooeye/core/constants/app_colors.dart';

class AnimalSearchCard extends StatelessWidget {
  final Map<String, dynamic> animal;
  final VoidCallback onTap;

  const AnimalSearchCard({
    super.key,
    required this.animal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.navBarBg.withValues(alpha:0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            // الصورة على اليسار
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/animals/${animal['id']}.jpg',
                width: 135,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 135,
                  color: AppColors.primaryGreen.withValues(alpha:0.1),
                  child: const Icon(Icons.pets, color: AppColors.primaryGreen),
                ),
              ),
            ),
            
            // النصوص على اليمين
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      animal['englishName'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppColors.primaryGreen,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      animal['arabicName'] ?? '',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5C4933),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildCategoryBadge(animal['category'] ?? ''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بادج الفصيلة الصغير
  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.primaryGreen,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}