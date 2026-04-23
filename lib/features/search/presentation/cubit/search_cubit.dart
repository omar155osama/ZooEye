import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zooeye/features/explore/data/repositories/animal_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  // تحميل كل الحيوانات عند فتح الشاشة
  void loadAnimals() {
    final animals = AnimalRepository.getAllAnimals();
    emit(SearchState(allAnimals: animals, filteredAnimals: animals));
  }

  // منطق البحث والفلترة
  void filterSearch(String query) {
    final normalizedQuery = query.toLowerCase().trim();
    
    if (normalizedQuery.isEmpty) {
      emit(state.copyWith(filteredAnimals: state.allAnimals, searchQuery: ''));
      return;
    }

    final filtered = state.allAnimals.where((animal) {
      final en = animal['englishName'].toString().toLowerCase();
      final ar = animal['arabicName'].toString();
      final sci = animal['scientificName'].toString().toLowerCase();
      return en.contains(normalizedQuery) || ar.contains(normalizedQuery) || sci.contains(normalizedQuery);
    }).toList();

    emit(state.copyWith(filteredAnimals: filtered, searchQuery: query));
  }
}