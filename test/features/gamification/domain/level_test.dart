import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/level.dart';

void main() {
  test('level 1 spans 0..99 XP', () {
    expect(levelForXp(0), 1);
    expect(levelForXp(99), 1);
  });

  test('level 2 starts exactly at 100 XP', () {
    expect(levelForXp(100), 2);
  });

  test('xpIntoCurrentLevel resets at each level boundary', () {
    expect(xpIntoCurrentLevel(0), 0);
    expect(xpIntoCurrentLevel(99), 99);
    expect(xpIntoCurrentLevel(100), 0);
    expect(xpIntoCurrentLevel(250), 50);
  });

  test('xpToNextLevel complements xpIntoCurrentLevel', () {
    expect(xpToNextLevel(0), xpPerLevel);
    expect(xpToNextLevel(90), 10);
    expect(xpToNextLevel(100), xpPerLevel);
  });
}
