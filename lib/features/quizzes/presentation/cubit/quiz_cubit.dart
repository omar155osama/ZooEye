import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zooeye/features/explore/data/repositories/animal_repository.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(const QuizState());

  final List<Map<String, dynamic>> _allAnimals = AnimalRepository.getAllAnimals();
  final int _totalQuestions = 5;

  void showMenu() => emit(const QuizState(gameType: QuizGameType.menu));

  void startGame(QuizGameType type) {
    emit(QuizState(gameType: type, score: 0, questionNumber: 1));
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    final correctAnimal = _allAnimals[random.nextInt(_allAnimals.length)];

    Set<String> optionsSet = {correctAnimal['arabicName']};
    while (optionsSet.length < 4) {
      optionsSet.add(_allAnimals[random.nextInt(_allAnimals.length)]['arabicName']);
    }

    final options = optionsSet.toList()..shuffle();

    emit(state.copyWith(
      currentAnimal: correctAnimal,
      options: options,
      isAnswered: false,
      selectedAnswer: null,
    ));
  }

  void checkAnswer(String answer) {
    if (state.isAnswered) return;

    final bool isCorrect = answer == state.currentAnimal!['arabicName'];
    final int newScore = isCorrect ? state.score + 1 : state.score;

    emit(state.copyWith(
      isAnswered: true,
      selectedAnswer: answer,
      score: newScore,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (isClosed) return;
      if (state.questionNumber < _totalQuestions) {
        emit(state.copyWith(questionNumber: state.questionNumber + 1));
        _generateQuestion();
      } else {
        emit(state.copyWith(isFinished: true));
      }
    });
  }
}