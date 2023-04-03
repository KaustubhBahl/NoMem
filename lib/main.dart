import 'package:flutter/material.dart';
import 'package:nomem/pages/home.dart';
import 'package:nomem/pages/accountslist.dart';
import 'package:nomem/pages/create_account.dart';

void main() {
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
          '/addAccount': (context) => const Create_account_page(),
          '/accountsList': (context) => const AccountsList(),
        });
  }
}
