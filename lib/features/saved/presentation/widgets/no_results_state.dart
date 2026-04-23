import 'package:flutter/material.dart';

class NoResultsState extends StatelessWidget {
  final String query;

  const NoResultsState( {super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'No matches found for "$query"',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}