import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zooeye/features/saved/presentation/widgets/animal_list_card.dart.dart';
import 'package:zooeye/features/saved/presentation/widgets/empty_saved_state.dart';
import 'package:zooeye/features/saved/presentation/widgets/no_results_state.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../../../../core/constants/app_colors.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تحميل البيانات إذا لم تكن محملة
    if (context.read<SavedCubit>().state is SavedInitial) {
      context.read<SavedCubit>().loadSaved();
    }

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved Animals',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  BlocBuilder<SavedCubit, SavedState>(
                    builder: (context, state) {
                      if (state is SavedLoaded) {
                        return Text(
                          '${state.allAnimals.length} animals',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),

            // 🌟 Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  onChanged: (value) =>
                      context.read<SavedCubit>().searchAnimals(value),
                  decoration: const InputDecoration(
                    hintText: 'Search animals...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // 🌟 List
            Expanded(
              child: BlocBuilder<SavedCubit, SavedState>(
                builder: (context, state) {
                  if (state is SavedLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreen,
                        ),
                      ),
                    );
                  }

                  if (state is SavedLoaded) {
                    if (state.allAnimals.isEmpty) {
                      return EmptySavedState();
                    }

                    if (state.filteredAnimals.isEmpty) {
                      return NoResultsState(query: state.searchQuery);
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: state.filteredAnimals.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final saved = state.filteredAnimals[index];
                        return AnimalListCard(savedItem: saved);
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
