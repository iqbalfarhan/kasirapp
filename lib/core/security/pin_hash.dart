import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// Hash PIN (SHA-256 + salt per user). Murni Dart, unit-testable.
/// Format PIN divalidasi di `LoginWithPin` (4–6 digit angka).
const _uuid = Uuid();

String generateSalt() => _uuid.v4();

String hashPin(String pin, String salt) =>
    sha256.convert(utf8.encode('$salt:$pin')).toString();

bool verifyPin(String pin, String salt, String expectedHash) =>
    hashPin(pin, salt) == expectedHash;
