import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/parental_control/domain/parent_pin.dart';

void main() {
  group('isValidParentPin', () {
    test('accepts exactly 4 digits', () {
      expect(isValidParentPin('1234'), isTrue);
      expect(isValidParentPin('0000'), isTrue);
    });

    test('rejects anything else', () {
      expect(isValidParentPin('123'), isFalse);
      expect(isValidParentPin('12345'), isFalse);
      expect(isValidParentPin('12a4'), isFalse);
      expect(isValidParentPin(''), isFalse);
    });
  });

  group('hashParentPin / verifyParentPin', () {
    test('the same pin and uid always hash the same way', () {
      expect(hashParentPin('1234', 'uid-1'), hashParentPin('1234', 'uid-1'));
    });

    test('different uids hash the same pin differently', () {
      expect(hashParentPin('1234', 'uid-1'), isNot(hashParentPin('1234', 'uid-2')));
    });

    test('verifyParentPin accepts the correct pin and rejects a wrong one', () {
      final hash = hashParentPin('4242', 'uid-1');
      expect(verifyParentPin(pin: '4242', uid: 'uid-1', storedHash: hash), isTrue);
      expect(verifyParentPin(pin: '0000', uid: 'uid-1', storedHash: hash), isFalse);
      // Same pin, wrong uid (e.g. a stale hash from another account).
      expect(verifyParentPin(pin: '4242', uid: 'uid-2', storedHash: hash), isFalse);
    });
  });
}
