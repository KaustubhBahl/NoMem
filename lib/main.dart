import 'package:flutter/material.dart';
import 'package:nomem/pages/home.dart';
import 'package:nomem/pages/accountslist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NoMem',
        theme: ThemeData(
            backgroundColor: const Color.fromRGBO(255, 251, 250, 1),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22))),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(232, 222, 248, 1)),
                    shadowColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(12)))),
        routes: {
          '/': (context) => const Home(),
          // '/addAccount': (context) => const AddAccount(),
          '/accountsList': (context) => const AccountsList(),
          // '/selectedAccount': (context) => const SelectedAccount()
        });
  }
}
