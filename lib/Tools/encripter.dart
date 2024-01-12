library dartencripter;

import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dart_des/dart_des.dart';

// ignore: camel_case_types
class Encriptador {
  static const String key = 'insepetModelKey';
  static const List<int> iv = [240, 3, 45, 29, 0, 76, 173, 59];

  String encrypter(String text) {
    try {
      final digest = crypto.md5.convert(key.codeUnits);
      // print("Digest as bytes: ${digest.bytes}");
      DES3 desCBC = DES3(
        key: digest.bytes,
        mode: DESMode.CBC,
        iv: iv,
        paddingType: DESPaddingType.PKCS7,
      );

      List<int> encrypted = desCBC.encrypt(text.codeUnits);

      return base64.encode(encrypted);
    } catch (e) {
      return "";
    }
  }

  String desencrypter(String text) {
    try {
      final digest = crypto.md5.convert(key.codeUnits);
      // print("Digest as bytes: ${digest.bytes}");
      DES3 desCBC = DES3(
        key: digest.bytes,
        mode: DESMode.CBC,
        iv: iv,
        paddingType: DESPaddingType.PKCS7,
      );

      List<int> decrypted = desCBC.decrypt(base64.decode(text));

      return utf8.decode(decrypted);
    } catch (e) {
      return "";
    }
  }
}
