import 'package:equatable/equatable.dart';

abstract class SavedState extends Equatable {
  const SavedState();
  
  @override
  List<Object?> get props => [];
}

class SavedInitial extends SavedState {}

class SavedLoading extends SavedState {}

class SavedLoaded extends SavedState {
  final List<Map<String, dynamic>> allAnimals; 
  final List<Map<String, dynamic>> filteredAnimals; 
  final String searchQuery;
  
  const SavedLoaded({
    required this.allAnimals,
    required this.filteredAnimals,
    this.searchQuery = '',
  });
  
  @override
  List<Object?> get props => [allAnimals, filteredAnimals, searchQuery];
}

class SavedError extends SavedState {
  final String message;
  
  const SavedError(this.message);
  
  @override
  List<Object?> get props => [message];
}