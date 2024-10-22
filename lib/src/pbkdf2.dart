import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:quiver/collection.dart';

class Pbkdf2 {
  final String Function() pepperFactory;

  Pbkdf2({required this.pepperFactory});

  String hash(final String password, {final String? salt}) {
    var saltData = _createSalt();
    if (salt != null && salt.isNotEmpty) {
      saltData = utf8.encode(salt);
    }
    final derivator = _initDerivator(saltData);

    final key = derivator.process(utf8.encode('${pepperFactory()}$password'));
    final encodedSalt = base64.encode(saltData);
    final encodedKey = base64.encode(key);

    return '$encodedKey,$encodedSalt';
  }

  bool verify(final String password, final String storedHashAndSalt) {
    List<String> parts = storedHashAndSalt.split(',');
    if (parts.length != 2) return false;

    final encodedKey = parts[0];
    final encodedSalt = parts[1];

    final salt = base64.decode(encodedSalt);
    final storedKey = base64.decode(encodedKey);

    final derivator = _initDerivator(salt);
    final derivedKey =
        derivator.process(utf8.encode('${pepperFactory()}$password'));

    return listsEqual(derivedKey, storedKey);
  }

  Uint8List _createSalt() {
    final rnd = SecureRandom('Fortuna');
    final seed = List.generate(32, (_) => Random.secure().nextInt(255));
    rnd.seed(KeyParameter(Uint8List.fromList(seed)));
    return rnd.nextBytes(16);
  }

  KeyDerivator _initDerivator(final Uint8List salt) {
    final iterationCount = 10000;
    final derivedKeyLength = 32;

    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));

    derivator.init(Pbkdf2Parameters(salt, iterationCount, derivedKeyLength));

    return derivator;
  }
}
