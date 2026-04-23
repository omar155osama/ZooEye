import 'package:equatable/equatable.dart';

enum QuizGameType { menu, picture, description }

class QuizState extends Equatable {
  final QuizGameType gameType;
  final int score;
  final int questionNumber;
  final bool isFinished;
  final bool isAnswered;
  final Map<String, dynamic>? currentAnimal;
  final List<String> options;
  final String? selectedAnswer;

  const QuizState({
    this.gameType = QuizGameType.menu,
    this.score = 0,
    this.questionNumber = 1,
    this.isFinished = false,
    this.isAnswered = false,
    this.currentAnimal,
    this.options = const [],
    this.selectedAnswer,
  });

  QuizState copyWith({
    QuizGameType? gameType,
    int? score,
    int? questionNumber,
    bool? isFinished,
    bool? isAnswered,
    Map<String, dynamic>? currentAnimal,
    List<String>? options,
    String? selectedAnswer,
  }) {
    return QuizState(
      gameType: gameType ?? this.gameType,
      score: score ?? this.score,
      questionNumber: questionNumber ?? this.questionNumber,
      isFinished: isFinished ?? this.isFinished,
      isAnswered: isAnswered ?? this.isAnswered,
      currentAnimal: currentAnimal ?? this.currentAnimal,
      options: options ?? this.options,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }

  @override
  List<Object?> get props => [
        gameType, score, questionNumber, isFinished, 
        isAnswered, currentAnimal, options, selectedAnswer
      ];
}