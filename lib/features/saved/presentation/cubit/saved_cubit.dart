import 'package:flutter_bloc/flutter_bloc.dart';
import 'saved_state.dart';
import '../../../../core/services/storage_service.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(SavedInitial());
  
  // 1. تحميل البيانات
  Future<void> loadSaved() async {
    try {
      emit(SavedLoading());
      final saved = await StorageService.getSavedAnimals();
      final reversedList = saved.reversed.toList();
      
      emit(SavedLoaded(
        allAnimals: reversedList,
        filteredAnimals: reversedList, 
        searchQuery: '',
      ));
    } catch (e) {
      emit(const SavedError('فشل تحميل الحيوانات المحفوظة'));
    }
  }
  
  // 2. البحث (Logic مفصول تماماً عن الـ UI)
  void searchAnimals(String query) {
    if (state is SavedLoaded) {
      final currentState = state as SavedLoaded;
      final lowerQuery = query.toLowerCase();
      
      final filtered = currentState.allAnimals.where((saved) {
        final animal = saved['animal'] as Map<String, dynamic>;
        final enName = (animal['englishName'] ?? '').toString().toLowerCase();
        final arName = (animal['arabicName'] ?? '').toString().toLowerCase();
        return enName.contains(lowerQuery) || arName.contains(lowerQuery);
      }).toList();
      
      emit(SavedLoaded(
        allAnimals: currentState.allAnimals,
        filteredAnimals: filtered,
        searchQuery: query,
      ));
    }
  }
  
  // 3. مسح حيوان
  Future<void> deleteAnimal(String id) async {
    try {
      await StorageService.deleteAnimal(id);
      await loadSaved(); // إعادة التحميل بعد المسح
    } catch (e) {
      emit(const SavedError('فشل الحذف'));
    }
  }
}