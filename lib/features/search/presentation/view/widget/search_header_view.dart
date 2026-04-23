import 'package:flutter/material.dart';
import 'package:zooeye/core/constants/app_colors.dart';

class SearchHeader extends StatelessWidget {
  final int count;

  const SearchHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          const Text(
            'Animal Dictionary',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryGreen,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            '$count animals',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}