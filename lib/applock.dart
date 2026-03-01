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
  bool _isAuthenticating = false;
  bool _authFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
      _authFailed = false;
    });

    bool authenticated = false;
    try {
      final bool canAuthenticate = await auth.canCheckBiometrics ||
          await auth.isDeviceSupported();

      if (!canAuthenticate) {
        debugPrint('NOMEM: Device does not support authentication');
        if (mounted) {
          setState(() {
            _isAuthenticating = false;
            _authFailed = true;
          });
        }
        return;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Unlock NoMem to proceed',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('NOMEM: Auth error code: ${e.code}');
      debugPrint('NOMEM: Auth error message: ${e.message}');
      authenticated = false;
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticating = false;
      _authFailed = !authenticated;
    });

    if (authenticated) {
      AppLock.of(context)?.didUnlock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isAuthenticating
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              'Authenticating...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 72,
            ),
            const SizedBox(height: 24),
            const Text(
              'NoMem is locked',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Authenticate to continue',
              style: TextStyle(fontSize: 14),
            ),
            if (_authFailed) ...[
              const SizedBox(height: 12),
              const Text(
                'Authentication failed. Please try again.',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _authenticate,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Unlock'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Exit App'),
            ),
          ],
        ),
      ),
    );
  }
}