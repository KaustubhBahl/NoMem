import 'package:crypto/crypto.dart';
import 'dart:convert';

class PasswordGen {
  final String domain, username, length, version, userKey;

  const PasswordGen(
      {required this.domain,
      required this.username,
      required this.length,
      required this.version,
      required this.userKey});

  String generatePassword() {
    final data = domain + username + length + version + userKey;
    var bytes = utf8.encode(data); // data being hashed
    var digest = sha512.convert(bytes);
    String digestHex = '$digest';
    var i = 0;
    var sum = 0;
    var len = int.parse(length);
    while (i < digestHex.length) {
      sum += digestHex[i].codeUnitAt(0);
      i++;
    }
    final password = digestHex.substring(0, len - 4) +
        String.fromCharCode(sum % 15 + '!'.codeUnitAt(0)) +
        String.fromCharCode(sum % 26 + 'A'.codeUnitAt(0)) +
        String.fromCharCode(sum % 26 + 'a'.codeUnitAt(0)) +
        String.fromCharCode(sum % 10 + '0'.codeUnitAt(0));
    return password;
  }
}
