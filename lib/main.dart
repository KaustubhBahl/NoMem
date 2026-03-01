import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nomem/applock.dart';
import 'package:nomem/pages/home.dart';
import 'package:nomem/pages/accountslist.dart';
import 'package:nomem/pages/create_account.dart';
import 'package:nomem/pages/about.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nomem/model/account.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

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
  await Hive.openBox<Account>(
    'accounts',
    encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
  );

  runApp(const NoMemApp());
}

class NoMemApp extends StatelessWidget {
  const NoMemApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoMem',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: AppLock(
        builder: (context, args) => const _MainNavigator(),
        lockScreenBuilder: (context) => const MyAppLock(),
        initiallyEnabled: true,
        initialBackgroundLockLatency: const Duration(seconds: 90),
      ),
    );
  }
}

class _MainNavigator extends StatelessWidget {
  const _MainNavigator();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/addAccount':
            page = const AddAccount();
            break;
          case '/accountsList':
            page = const AccountsList();
            break;
          case '/about':
            page = const AboutPage();
            break;
          default:
            page = const Home();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}