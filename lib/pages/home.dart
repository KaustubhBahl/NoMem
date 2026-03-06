import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomem/backup.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    precacheImage(
        const AssetImage('assets/images/nomem_home_logo.jpeg'), context);
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 150),
              Image.asset('assets/images/nomem_home_logo.jpeg', scale: 1.8),
              const SizedBox(height: 20),
              Text(
                'One stop solution to secure\npassword management',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 100),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _HomeButton(
                      icon: Icons.add,
                      label: 'Generate new password',
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/addAccount'),
                    ),
                    const SizedBox(height: 12),
                    _HomeButton(
                      icon: Icons.visibility_outlined,
                      label: 'View Password',
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/accountsList'),
                    ),
                    const SizedBox(height: 12),
                    _HomeButton(
                      icon: Icons.file_upload,
                      label: 'Import accounts',
                      onPressed: () async {
                        var msg = await Import().import();
                        if (msg != 'Cancelled') {
                          Fluttertoast.showToast(
                            msg: msg,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _HomeButton(
                      icon: Icons.file_download,
                      label: 'Export accounts',
                      onPressed: () async {
                        var msg = '';
                        if (await Export().export()) {
                          msg =
                          'Data file exported to Download folder successfully';
                        } else {
                          msg =
                          "Data wasn't exported as couldn't open Download folder";
                        }
                        Fluttertoast.showToast(
                          msg: msg,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _HomeButton(
                      icon: Icons.info_outline,
                      label: 'About & Legal',
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/about'),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: colorScheme.surfaceVariant,
        height: 70,
        child: Center(
          child: Text(
            'The 307 Initiative',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _HomeButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}