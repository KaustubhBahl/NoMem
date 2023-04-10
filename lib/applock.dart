import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:local_auth/local_auth.dart';

class MyAppLock extends StatefulWidget {
  const MyAppLock({Key? key}) : super(key: key);

  @override
  State<MyAppLock> createState() => _MyAppLockState();
}

class _MyAppLockState extends State<MyAppLock> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) =>
          setState(() =>
          _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
    );
    _authenticate();
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Unlock the app to proceed',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
    if(_authorized == 'Authorized') {
      AppLock.of(context)!.didUnlock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: _isAuthenticating ? const SizedBox.shrink() : Theme(
            data: ThemeData(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color.fromRGBO(255, 255, 245, 1),
              ),
            ),
            child: AlertDialog(
              title: const Text('Authentication Required'),
              content: const Text(
                'Please unlock the app to proceed',
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await _authenticate();
                  },
                  child: const Text('Unlock'),
                ),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          )
      );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}