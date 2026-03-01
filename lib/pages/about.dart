import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('About & Legal'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              colorScheme: colorScheme,
              icon: Icons.info_outline,
              title: 'About NoMem',
              content:
              'NoMem is a deterministic password manager. It does not store your passwords anywhere. '
                  'Instead, it generates your password on demand using a combination of your master key, '
                  'domain name, username, password length, and version number.\n\n'
                  'The same inputs will always produce the same password, meaning as long as you remember '
                  'your master key, you can always recover any password. No cloud sync, no password vault, '
                  'no risk of a data breach exposing your passwords.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              colorScheme: colorScheme,
              icon: Icons.menu_book_outlined,
              title: 'How to Use',
              content:
              '1. Tap "Generate new password" on the home screen.\n\n'
                  '2. Enter the domain (e.g. Google, Facebook), your username/email, '
                  'and your secret master key.\n\n'
                  '3. Leave version as 1 for new accounts. The length defaults to 12 characters '
                  '(you can change this).\n\n'
                  '4. Tap "Generate Password" — your password is shown and can be copied to clipboard.\n\n'
                  '5. To retrieve a password later, go to "View Password", tap the account, '
                  'enter your master key, and tap "View Password".\n\n'
                  '6. To change a password, tap "Update Password" on the account details screen. '
                  'The version number increases by 1, producing a new password.\n\n'
                  '7. Use Export regularly to back up your account list (not passwords — '
                  'those can always be regenerated).',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              colorScheme: colorScheme,
              icon: Icons.security_outlined,
              title: 'Security Notes',
              content:
              '• Your master key is never stored on the device or transmitted anywhere.\n\n'
                  '• Account metadata (domain, username, length, version) is stored locally '
                  'in an AES-encrypted database secured by your device keystore.\n\n'
                  '• Biometric/device lock is required to open the app.\n\n'
                  '• NoMem does not require internet access and makes no network connections.\n\n'
                  '• If you lose your master key, there is no recovery option. '
                  'Store it somewhere safe.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              colorScheme: colorScheme,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              content:
              'NoMem collects no personal data. It does not use analytics, advertising SDKs, '
                  'crash reporting services, or any form of telemetry. No data is transmitted '
                  'to any server at any time.\n\n'
                  'All data remains exclusively on your device. The export feature saves a file '
                  'to your device\'s Downloads folder only when you explicitly initiate it.\n\n'
                  'This app does not access contacts, camera, microphone, location, or any '
                  'other sensitive device features beyond biometric authentication and local storage.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              colorScheme: colorScheme,
              icon: Icons.gavel_outlined,
              title: 'Terms & Conditions',
              content:
              'By using NoMem, you agree to the following:\n\n'
                  '1. This app is provided "as is" without any warranty of any kind, '
                  'express or implied.\n\n'
                  '2. The developers are not responsible for any loss of access to accounts '
                  'resulting from forgotten master keys, lost devices, uninstallation, '
                  'or any other cause.\n\n'
                  '3. You are solely responsible for maintaining the secrecy of your master key.\n\n'
                  '4. You are solely responsible for regularly exporting your account list '
                  'as a backup.\n\n'
                  '5. The developers make no guarantees about the cryptographic strength of the '
                  'password generation algorithm for any specific security requirement.\n\n'
                  '6. This app is intended for personal use only.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              colorScheme: colorScheme,
              icon: Icons.warning_amber_outlined,
              title: 'Disclaimer',
              content:
              'NoMem is a personal productivity tool and is not a certified or audited '
                  'cryptographic security product. While we take reasonable steps to protect '
                  'your data on-device, we make no representations about its suitability for '
                  'high-security environments.\n\n'
                  'Passwords generated by this app are based on a deterministic algorithm. '
                  'If your master key is compromised, all generated passwords should be '
                  'considered compromised. Change your passwords immediately if you suspect '
                  'your master key has been exposed.\n\n'
                  'The developers of NoMem accept no liability for any damages, direct or '
                  'indirect, arising from the use or inability to use this application.',
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'NoMem v1.0.0 • Made by G5',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final ColorScheme colorScheme;
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.colorScheme,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: colorScheme.onSurfaceVariant.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}