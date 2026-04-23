import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
  
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {
  final String message;
  final File? image; 
  
  const ExploreLoading({this.message = 'جاري التحليل...', this.image});
  
  @override
  List<Object?> get props => [message, image];
}

// 🌟 تعريف واحد فقط للـ Success، متوافق مع Equatable ونوعه Map
class ExploreSuccess extends ExploreState {
  final Map<String, dynamic> animal; 
  final File image; 
  final bool isFromAI;
  
  const ExploreSuccess({
    required this.animal,
    required this.image,
    this.isFromAI = false,
  });
  
  @override
  List<Object?> get props => [animal, image, isFromAI];
}

class ExploreError extends ExploreState {
  final String message;
  
  const ExploreError(this.message);
  
  @override
  List<Object?> get props => [message];
}