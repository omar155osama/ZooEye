import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zooeye/features/quizzes/presentation/quizzes_screen.dart';
import 'package:zooeye/features/saved/presentation/cubit/saved_cubit.dart';
import 'package:zooeye/features/search/presentation/search_screen.dart';
import '../../../../core/constants/app_colors.dart';

import '../cubit/explore_cubit.dart';
import '../cubit/explore_state.dart';
import '../widgets/bottom_nav_bar.dart';
import 'explore_view.dart'; 
import '../../../saved/presentation/views/saved_screen.dart';


class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  String _activeTab = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          return Stack(
            children: [
              // 1. عرض التابات
             IndexedStack(
                index: _activeTab == 'home' ? 0 : 
                       _activeTab == 'search' ? 1 : 
                       _activeTab == 'quiz' ? 2 : 3,
                children: [
                  ExploreView(state: state),       // 0: الكاميرا
                  const SearchScreen(),            // 1: البحث (القاموس)
                  const QuizzesScreen(),           // 2: المسابقات
                  const SavedScreen()              // 3: المحفوظات
                ],
              ),

              // 2. شريط التنقل السفلي (يظهر فقط في الشاشة الرئيسية)
              if (state is ExploreInitial)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomNavBar(
                    activeTab: _activeTab,
                    onTabChange: (tab) {
                      setState(() => _activeTab = tab);
                      if (tab == 'saved') {
                        context.read<SavedCubit>().loadSaved();
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}