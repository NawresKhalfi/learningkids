/// One multiple-choice question shown after a lesson (US21), with a real
/// pedagogical explanation shown after answering regardless of the
/// outcome, not just "wrong" (US22).
class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;
}
