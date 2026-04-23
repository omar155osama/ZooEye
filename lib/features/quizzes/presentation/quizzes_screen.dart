import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zooeye/features/quizzes/presentation/cubit/quiz_cubit.dart';
import 'package:zooeye/features/quizzes/presentation/cubit/quiz_state.dart';
import '../../../../core/constants/app_colors.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🌟 توفير الـ Cubit للشاشة
    return BlocProvider(
      create: (context) => QuizCubit(),
      child: const QuizzesViewBody(),
    );
  }
}

class QuizzesViewBody extends StatelessWidget {
  const QuizzesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              child: Column(
                children: [
                  _buildTopBar(context, state),
                  const SizedBox(height: 20),

                  // 🌟 التبديل بين الحالات بناءً على الـ State
                  if (state.gameType == QuizGameType.menu)
                    _buildMenu(context)
                  else if (state.isFinished)
                    _buildResults(context, state)
                  else
                    _buildQuizCore(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 1. شريط العنوان
  Widget _buildTopBar(BuildContext context, QuizState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (state.gameType != QuizGameType.menu)
          _buildCircleBtn(
            Icons.arrow_back_ios_new,
            () => context.read<QuizCubit>().showMenu(),
          )
        else
          const SizedBox(width: 40),
        const Text(
          'ZooEye Quiz',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  // 2. قائمة الألعاب
  Widget _buildMenu(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text('🧩', style: TextStyle(fontSize: 70)),
        const SizedBox(height: 10),
        const Text(
          'اختبر معلوماتك بره الحديقة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 40),
        _buildGameCard(
          context,
          '🖼️',
          'خمن الصورة',
          'تعرف على الحيوان من شكله',
          AppColors.primaryGreen,
          QuizGameType.picture,
        ),
        const SizedBox(height: 16),
        _buildGameCard(
          context,
          '🕵️',
          'من أنا؟',
          'خمن الحيوان من مواصفاته الخاصة',
          AppColors.accentOrange,
          QuizGameType.description,
        ),
      ],
    );
  }

  // 3. جوهر اللعبة (الأسئلة)
  Widget _buildQuizCore(BuildContext context, QuizState state) {
    if (state.currentAnimal == null) return const SizedBox();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: state.questionNumber / 5, // إجمالي الأسئلة
            minHeight: 8,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${state.questionNumber}/5',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Text(
              'Score: ${state.score}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.accentOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 20),
            ],
          ),
          child: state.gameType == QuizGameType.picture
              ? _buildPictureArea(state.currentAnimal!['id'])
              : _buildDescriptionArea(state.currentAnimal!),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'خمن اسم الحيوان؟',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),

        ...state.options.map((opt) => _buildOption(context, state, opt)),
      ],
    );
  }

  // 4. شاشة النتائج
  Widget _buildResults(BuildContext context, QuizState state) {
    return Column(
      children: [
        const SizedBox(height: 60),
        const Text('🏁', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 10),
        const Text(
          'انتهى التحدي!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          '${state.score} / 5',
          style: const TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 40),
        _buildActionBtn(
          'إعادة المحاولة',
          AppColors.primaryGreen,
          () => context.read<QuizCubit>().startGame(state.gameType),
        ),
        const SizedBox(height: 12),
        _buildActionBtn(
          'العودة للقائمة',
          Colors.black45,
          () => context.read<QuizCubit>().showMenu(),
          isFull: false,
        ),
      ],
    );
  }

  // --- Widgets مساعدة ---

  Widget _buildPictureArea(int id) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Image.asset('assets/animals/$id.jpg', fit: BoxFit.cover),
    );
  }

  Widget _buildDescriptionArea(Map<String, dynamic> animal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navBarBg.withValues(alpha:0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHintRow('📍', 'الموطن', animal['habitat'] ?? '??'),
          _buildDivider(),
          _buildHintRow('🍽️', 'الغذاء', animal['diet'] ?? '??'),
          _buildDivider(),
          _buildHintRow('⚖️', 'الوزن', animal['weight'] ?? '??'),
        ],
      ),
    );
  }

  Widget _buildHintRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
              fontFamily: 'Cairo',
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
    height: 1,
    thickness: 1,
    color: AppColors.primaryGreen.withValues(alpha:0.05),
  );

  Widget _buildOption(BuildContext context, QuizState state, String opt) {
    bool isCorrect =
        state.isAnswered && opt == state.currentAnimal!['arabicName'];
    bool isWrong =
        state.isAnswered &&
        opt == state.selectedAnswer &&
        opt != state.currentAnimal!['arabicName'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.read<QuizCubit>().checkAnswer(opt),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isCorrect
                ? Colors.green.withValues(alpha:0.1)
                : (isWrong ? Colors.red.withValues(alpha:0.1) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCorrect
                  ? Colors.green
                  : (isWrong ? Colors.red : Colors.black.withValues(alpha:0.05)),
              width: 2,
            ),
          ),
          child: Text(
            opt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String emoji,
    String title,
    String sub,
    Color color,
    QuizGameType type,
  ) {
    return InkWell(
      onTap: () => context.read<QuizCubit>().startGame(type),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha:0.1), width: 2),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.play_arrow_rounded, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(
    String label,
    Color color,
    VoidCallback onTap, {
    bool isFull = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isFull
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : TextButton(
              onPressed: onTap,
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 18, color: AppColors.primaryGreen),
      ),
    );
  }
}
