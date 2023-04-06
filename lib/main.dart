import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nomem/pages/home.dart';
import 'package:nomem/pages/accountslist.dart';
import 'package:nomem/pages/create_account.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nomem/model/account.dart';

void main() async {
  await Hive.initFlutter();
  const secureStorage = FlutterSecureStorage();
  // if key not exists return null
  final encryptionKeyString = await secureStorage.read(key: 'key');
  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptionKeyUint8List = base64Url.decode(key!);
  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox('accounts', encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NoMem',
        routes: {
          '/': (context) => const Home(),
          '/addAccount': (context) => const AddAccount(),
          '/accountsList': (context) => const AccountsList(),
        });
  }
}
