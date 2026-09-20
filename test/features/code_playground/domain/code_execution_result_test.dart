import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/code_execution_result.dart';
import 'package:learningkids/features/code_playground/domain/execution_error.dart';

void main() {
  test('hasError is false for plain output', () {
    const result = CodeExecutionResult.output('hello');
    expect(result.hasError, isFalse);
    expect(result.stdout, 'hello');
  });

  test('hasError is true once an error is attached', () {
    const result = CodeExecutionResult(
      stdout: '',
      error: ExecutionError(line: 1, errorType: 'NameError', message: "name 'x' is not defined"),
    );
    expect(result.hasError, isTrue);
  });
}
