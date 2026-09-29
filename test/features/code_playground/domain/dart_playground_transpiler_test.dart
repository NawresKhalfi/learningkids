import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/dart_playground_transpiler.dart';

void main() {
  test('transpiles the mobile quiz Dart template to runnable JavaScript', () {
    const dartCode = '''
class Question { const Question(this.prompt, this.answer); final String prompt; final String answer; }
void main() {
  const question = Question('Quel widget ?', 'Text');
  const response = 'Text';
  print(response == question.answer ? 'Bonne réponse !' : 'Essaie encore.');
}
''';

    final javascript = transpileDartForPlayground(dartCode);

    expect(javascript, contains('class Question'));
    expect(javascript, contains('new Question'));
    expect(javascript, contains('console.log('));
    expect(javascript, isNot(contains('void main')));
  });
}
