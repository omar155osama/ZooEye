import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zooeye/core/constants/app_colors.dart';
import 'package:zooeye/core/services/storage_service.dart';
import 'package:zooeye/core/utils/color_helper.dart';
import 'package:zooeye/features/explore/presentation/widgets/detail_card.dart';
import 'package:zooeye/features/explore/presentation/widgets/detail_hero_widget.dart';
import 'package:zooeye/features/saved/presentation/cubit/saved_cubit.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> animal;
  final File capturedImage;
  final bool isFromAI;
  final bool isSaved;
  final VoidCallback onBack;
  final VoidCallback? onSave;

  const DetailScreen({
    super.key,
    required this.animal,
    required this.capturedImage,
    required this.isFromAI,
    required this.onBack,
    this.isSaved = false,
    this.onSave,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = widget.isSaved;
  }

  Future<void> _handleSave() async {
    final bool newSavedState = !_saved;

    // تغيير شكل الزرار فوراً بدون أنيميشن
    setState(() {
      _saved = newSavedState;
    });

    if (newSavedState) {
      bool isSuccess = await StorageService.saveAnimal(
        animal: widget.animal,
        imageFile: widget.capturedImage,
        isFromAI: widget.isFromAI,
      );

      if (mounted) {
        if (isSuccess) {
          context.read<SavedCubit>().loadSaved();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ تم الحفظ بنجاح!'),
              backgroundColor: AppColors.primaryGreen,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // لو المساحة ممتلئة نرجع الزرار لأصله
          setState(() => _saved = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ فشل الحفظ. تأكد من وجود مساحة كافية على هاتفك.'),
              backgroundColor: Color(0xFFD9534F),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم الإزالة من المحفوظات'),
            backgroundColor: Color(0xFFD9534F),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    if (widget.onSave != null) {
      widget.onSave!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String statusText = widget.animal['conservation'] ?? 'Unknown';
    final statusColor = ColorHelper.getStatusColor(statusText);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DetailHeroWidget(
                  animal: widget.animal,
                  capturedImage: widget.capturedImage,
                  onBack: widget.onBack,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildBadge(
                          emoji: '🏷️',
                          label: widget.animal['category'] ?? 'Unknown',
                          color: AppColors.primaryGreen,
                        ),
                        _buildBadge(
                          emoji: '🔒',
                          label: statusText,
                          color: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ... داخل SliverChildListDelegate
                    DetailCard(
                      icon: '🧬',
                      label: 'Scientific Name',
                      labelAr: 'الاسم العلمي',
                      content: widget.animal['scientificName'] ?? 'غير متوفر',
                    ),
                    DetailCard(
                      icon: '⚖️',
                      label: 'Weight',
                      labelAr: 'الوزن',
                      content: widget.animal['weight'] ?? 'غير متوفر',
                    ),
                    DetailCard(
                      icon: '🛡️',
                      label: 'Conservation',
                      labelAr: 'حالة الحفظ',
                      content: widget.animal['conservation'] ?? 'غير متوفر',
                    ),
                    // باقي الكروت (الموطن، الغذاء، إلخ...)
                    DetailCard(
                      icon: '📍',
                      label: 'Habitat',
                      labelAr: 'الموطن',
                      content: widget.animal['habitat'] ?? 'غير متوفر',
                    ),
                    DetailCard(
                      icon: '🍽️',
                      label: 'Diet',
                      labelAr: 'الغذاء',
                      content: widget.animal['diet'] ?? 'Unknown',
                    ),
                    DetailCard(
                      icon: '⏱️',
                      label: 'Lifespan',
                      labelAr: 'مدة الحياة',
                      content: widget.animal['lifespan'] ?? 'Unknown',
                    ),
                    if (widget.animal['description'] != null &&
                        widget.animal['description'].toString().isNotEmpty)
                      DetailCard(
                        icon: '📖',
                        label: 'Description',
                        labelAr: 'الوصف',
                        content: widget.animal['description'],
                      ),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(bottom: 40, right: 20, child: _buildSaveButton()),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String emoji,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.45,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Cairo',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _handleSave,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: _saved ? AppColors.accentOrange : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _saved ? Icons.bookmark : Icons.bookmark_border,
          color: _saved ? Colors.white : AppColors.primaryGreen,
          size: 28,
        ),
      ),
    );
  }
}
