import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/domain/account_summary.dart';

void main() {
  test('fromMap defaults isSuspended to false (joined in separately)', () {
    final account = AccountSummary.fromMap('kid-1', {'pseudo': 'Léo', 'avatarId': 'fox'});

    expect(account.uid, 'kid-1');
    expect(account.pseudo, 'Léo');
    expect(account.avatarId, 'fox');
    expect(account.isSuspended, isFalse);
  });

  test('copyWith overrides only isSuspended', () {
    const account = AccountSummary(uid: 'kid-1', pseudo: 'Léo', avatarId: 'fox', isSuspended: false);

    final suspended = account.copyWith(isSuspended: true);

    expect(suspended.uid, account.uid);
    expect(suspended.pseudo, account.pseudo);
    expect(suspended.isSuspended, isTrue);
  });
}
