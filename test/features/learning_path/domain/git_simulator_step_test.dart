import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/git_simulator_step.dart';

void main() {
  test('scenario is non-empty and well-formed', () {
    expect(gitSimulatorScenario, isNotEmpty);
    for (final step in gitSimulatorScenario) {
      expect(step.instruction, isNotEmpty);
      expect(step.commandOptions.length, greaterThanOrEqualTo(2));
      expect(step.commandOptions, contains(step.correctCommand));
      expect(step.resultDescription, isNotEmpty);
    }
  });

  test('every step has a unique correct command', () {
    final correctCommands = gitSimulatorScenario.map((s) => s.correctCommand).toSet();
    expect(correctCommands.length, gitSimulatorScenario.length);
  });
}
