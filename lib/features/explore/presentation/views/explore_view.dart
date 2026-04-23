import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/explore_cubit.dart';
import '../cubit/explore_state.dart';
import 'home_screen.dart';
import 'detail_view.dart';
import 'loading_view.dart';
import 'explore_error_view.dart';

class ExploreView extends StatelessWidget {
  final ExploreState state;

  const ExploreView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is ExploreLoading) {
      return LoadingScreen(onComplete: () {});
    }

    if (state is ExploreSuccess) {
      final successState = state as ExploreSuccess;
      return DetailScreen(
        animal: successState.animal,
        capturedImage: successState.image,
        isFromAI: successState.isFromAI,
        isSaved: false,
        onBack: () => context.read<ExploreCubit>().reset(),
      );
    }

    if (state is ExploreError) {
      final errorState = state as ExploreError;
      return ExploreErrorView(message: errorState.message);
    }

    return const HomeScreen();
  }
}