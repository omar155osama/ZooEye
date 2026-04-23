import 'package:flutter/material.dart';

class EmptySavedState extends StatelessWidget {
  const EmptySavedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌿', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 12),
          const Text(
            'No animals saved yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start scanning animals to build your collection!',
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF666666).withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}