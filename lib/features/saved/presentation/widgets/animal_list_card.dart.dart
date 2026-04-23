import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../explore/presentation/views/detail_view.dart';
import '../cubit/saved_cubit.dart';

class AnimalListCard extends StatelessWidget {
  final Map<String, dynamic> savedItem;

  const AnimalListCard({super.key, required this.savedItem});

  @override
  Widget build(BuildContext context) {
    final animal = savedItem['animal'] as Map<String, dynamic>;
    final imagePath = savedItem['imagePath'] as String;

    return Dismissible(
      key: Key(savedItem['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD9534F),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        context.read<SavedCubit>().deleteAnimal(savedItem['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${animal['englishName']} removed from saved'),
            backgroundColor: const Color(0xFFD9534F),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                animal: animal,
                capturedImage: File(imagePath),
                isFromAI: savedItem['isFromAI'] ?? false,
                isSaved: true,
                onSave: () => context.read<SavedCubit>().loadSaved(),
                onBack: () => Navigator.pop(context),
              ),
            ),
          ).then((_) {
            if (context.mounted) context.read<SavedCubit>().loadSaved();
          });
        },
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 120,
                  child: imagePath.isNotEmpty
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A2E0A), Color(0xFF2D4A18)],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          animal['englishName'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (animal['arabicName'] != null)
                          Text(
                            animal['arabicName'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.6),
                              fontFamily: 'Cairo',
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            _buildSmallBadge(
                              label: animal['category'] ?? 'Unknown',
                              bgColor: Colors.white.withValues(alpha: 0.12),
                              textColor: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 5),
                            _buildSmallBadge(
                              label:
                                  animal['status'] ??
                                  animal['conservation'] ??
                                  'Unknown',
                              bgColor: Colors.white.withValues(alpha: 0.12),
                              textColor: Colors.white.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              '⏱️ ${animal['lifespan']?.split(' ').first ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '🍽️ ${animal['diet']?.split('-').first ?? 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.55),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallBadge({
    required String label,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primaryGreen.withValues(alpha: 0.1),
      child: const Center(child: Text('🦁', style: TextStyle(fontSize: 48))),
    );
  }
}
