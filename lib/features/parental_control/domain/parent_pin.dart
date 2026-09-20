import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Hashes/verifies the 4-digit parent PIN that gates the Espace Parent
/// (US07). This is a lightweight app-side gate, not a real auth factor —
/// hashing it (salted with the user's own uid) just avoids keeping a
/// plaintext secret in Firestore, it does not need to be cryptographically
/// hardened like a password.
String hashParentPin(String pin, String uid) =>
    sha256.convert(utf8.encode('$uid:$pin')).toString();

bool verifyParentPin({
  required String pin,
  required String uid,
  required String storedHash,
}) =>
    hashParentPin(pin, uid) == storedHash;

/// A PIN must be exactly 4 digits.
bool isValidParentPin(String pin) => RegExp(r'^\d{4}$').hasMatch(pin);
