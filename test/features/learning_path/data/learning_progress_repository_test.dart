import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/data/learning_progress_repository.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';

void main() {
  late LearningProgressRepository repository;

  setUp(() {
    repository = LearningProgressRepository(firestore: FakeFirebaseFirestore());
  });

  test('fetchProgress returns an empty progress before anything is set', () async {
    final progress = await repository.fetchProgress('uid-1');
    expect(progress.activePaths, isEmpty);
  });

  test('activatePath then fetchProgress reports the path as active', () async {
    await repository.activatePath('uid-1', LearningPath.frontEnd);
    final progress = await repository.fetchProgress('uid-1');
    expect(progress.isActive(LearningPath.frontEnd), isTrue);
  });

  test('activating the same path twice does not duplicate it', () async {
    await repository.activatePath('uid-1', LearningPath.frontEnd);
    await repository.activatePath('uid-1', LearningPath.frontEnd);
    final progress = await repository.fetchProgress('uid-1');
    expect(progress.activePaths.length, 1);
  });

  test('deactivatePath removes a path from the active set', () async {
    await repository.activatePath('uid-1', LearningPath.python);
    await repository.deactivatePath('uid-1', LearningPath.python);
    final progress = await repository.fetchProgress('uid-1');
    expect(progress.isActive(LearningPath.python), isFalse);
  });

  test('markModuleCompleted only affects the given path\'s list', () async {
    await repository.markModuleCompleted('uid-1', LearningPath.frontEnd, 'frontend-1');

    final progress = await repository.fetchProgress('uid-1');
    expect(progress.completedIdsFor(LearningPath.frontEnd), {'frontend-1'});
    expect(progress.completedIdsFor(LearningPath.python), isEmpty);
  });

  test('markModuleCompleted records the quiz score when given (EP09/US51)', () async {
    await repository.markModuleCompleted('uid-1', LearningPath.frontEnd, 'frontend-1', correctAnswers: 1);

    final progress = await repository.fetchProgress('uid-1');
    expect(progress.quizScoreFor('frontend-1'), 1);
  });

  test('a later completion overwrites the previous quiz score', () async {
    await repository.markModuleCompleted('uid-1', LearningPath.frontEnd, 'frontend-1', correctAnswers: 1);
    await repository.markModuleCompleted('uid-1', LearningPath.frontEnd, 'frontend-1', correctAnswers: 2);

    final progress = await repository.fetchProgress('uid-1');
    expect(progress.quizScoreFor('frontend-1'), 2);
  });

  test('completing two paths independently keeps their progress separate (US18)', () async {
    await repository.markModuleCompleted('uid-1', LearningPath.frontEnd, 'frontend-1');
    await repository.markModuleCompleted('uid-1', LearningPath.python, 'python-1');
    await repository.markModuleCompleted('uid-1', LearningPath.python, 'python-2');

    final progress = await repository.fetchProgress('uid-1');
    expect(progress.completedIdsFor(LearningPath.frontEnd), {'frontend-1'});
    expect(progress.completedIdsFor(LearningPath.python), {'python-1', 'python-2'});
  });

  test('saveLessonStep persists and overwrites a module\'s reading position (US25)', () async {
    await repository.saveLessonStep('uid-1', 'frontend-2', 1);
    expect((await repository.fetchProgress('uid-1')).stepIndexFor('frontend-2'), 1);

    await repository.saveLessonStep('uid-1', 'frontend-2', 2);
    expect((await repository.fetchProgress('uid-1')).stepIndexFor('frontend-2'), 2);
  });

  test('lesson steps for different modules do not overwrite each other', () async {
    await repository.saveLessonStep('uid-1', 'frontend-1', 1);
    await repository.saveLessonStep('uid-1', 'python-1', 2);

    final progress = await repository.fetchProgress('uid-1');
    expect(progress.stepIndexFor('frontend-1'), 1);
    expect(progress.stepIndexFor('python-1'), 2);
  });
}
