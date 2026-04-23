import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final List<Map<String, dynamic>> allAnimals;
  final List<Map<String, dynamic>> filteredAnimals;
  final String searchQuery;

  const SearchState({
    this.allAnimals = const [],
    this.filteredAnimals = const [],
    this.searchQuery = '',
  });

  SearchState copyWith({
    List<Map<String, dynamic>>? allAnimals,
    List<Map<String, dynamic>>? filteredAnimals,
    String? searchQuery,
  }) {
    return SearchState(
      allAnimals: allAnimals ?? this.allAnimals,
      filteredAnimals: filteredAnimals ?? this.filteredAnimals,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allAnimals, filteredAnimals, searchQuery];
}