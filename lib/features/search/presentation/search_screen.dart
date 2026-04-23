import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zooeye/features/search/presentation/cubit/search_cubit.dart';
import 'package:zooeye/features/search/presentation/cubit/search_state.dart';
import 'package:zooeye/features/search/presentation/view/widget/animal_search_card_view.dart';
import 'package:zooeye/features/search/presentation/view/widget/search_header_view.dart';
import '../../../../core/constants/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit()..loadAnimals(),
      child: const SearchViewBody(),
    );
  }
}

class SearchViewBody extends StatelessWidget {
  const SearchViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return Column(
              children: [
                // 1. رأس الصفحة (العنوان والعدد)
                SearchHeader(count: state.filteredAnimals.length),

                // 2. حقل البحث
                _buildSearchField(context),

                const SizedBox(height: 15),

                // 3. منطقة النتائج
                Expanded(
                  child: state.filteredAnimals.isEmpty
                      ? NoResultsState(
                          query: state.searchQuery,
                        ) // 🌟 استخدام الويدجت الجديدة
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                          itemCount: state.filteredAnimals.length,
                          itemBuilder: (context, index) {
                            final animal = state.filteredAnimals[index];
                            return AnimalSearchCard(
                              animal: animal,
                              onTap: () => _showAnimalDetails(context, animal),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha:  0.08), width: 1.5),
        ),
        child: TextField(
          onChanged: (val) => context.read<SearchCubit>().filterSearch(val),
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
            hintText: 'Search animals...',
            prefixIcon: Icon(Icons.search, color: AppColors.primaryGreen),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  // 🌟 الـ Bottom Sheet الكاملة (نصوص وفواصل)
  void _showAnimalDetails(BuildContext context, Map<String, dynamic> animal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                child: Image.asset(
                  'assets/animals/${animal['id']}.jpg',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      animal['englishName'] ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      animal['arabicName'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryGreen,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.5),

                    _infoRow('🦁 الفصيلة', animal['category']),
                    _infoRow('🧬 الاسم العلمي', animal['scientificName']),
                    _infoRow('⚖️ الوزن المتوقع', animal['weight']),
                    _infoRow('🛡️ حالة الحفظ', animal['conservation']),
                    _infoRow('📍 الموطن الأصلي', animal['habitat']),
                    _infoRow('🍽️ نوع الغذاء', animal['diet']),
                    _infoRow('⏱️ متوسط العمر', animal['lifespan']),

                    const SizedBox(height: 20),
                    const Text(
                      'نبذة عن الحيوان',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      animal['description'] ?? '',
                      style: const TextStyle(fontSize: 15, height: 1.6),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.black.withValues(alpha:0.05)),
      ],
    );
  }
}

class NoResultsState extends StatelessWidget {
  final String query;

  const NoResultsState({super.key, required this.query});

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
              fontFamily: 'Cairo', // ضفنا الكايرو عشان التناسق
            ),
          ),
        ],
      ),
    );
  }
}
