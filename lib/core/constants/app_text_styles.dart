import 'package:flutter/material.dart';

class AppTextStyles {
  static const heroTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [Shadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 4)],
  );
  
  static const heroSubtitle = TextStyle(
    fontSize: 20,
    color: Colors.white,
    shadows: [Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 3)],
  );
  
  static const pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  
  static const cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  static const cardContent = TextStyle(
    fontSize: 15,
    height: 1.5,
  );
}