import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/quiz_question.dart';

void main() {
  const question = QuizQuestion(
    prompt: '2 + 2 ?',
    options: ['3', '4', '5'],
    correctIndex: 1,
    explanation: '2 + 2 = 4.',
  );

  test('isCorrect is true only for the correct index', () {
    expect(question.isCorrect(1), isTrue);
    expect(question.isCorrect(0), isFalse);
    expect(question.isCorrect(2), isFalse);
  });
}
