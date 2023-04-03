import 'package:flutter/material.dart';

class AccountDetailsPage extends StatefulWidget {
  final String domain;
  final String username;
  final int passwordLength;
  final int versionNumber;

  const AccountDetailsPage({
    Key? key,
    required this.domain,
    required this.username,
    required this.passwordLength,
    required this.versionNumber,
  }) : super(key: key);

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  bool _showPassword = false;
  late String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 251, 250, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(232, 222, 248, 1),
        centerTitle: true,
        title: Text(
            'Account Details',
            style: TextStyle(
              color: Color(0xFF1C1B1F),
            ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Color(0xFF49454F)),
          onPressed: () {
            //Navigate to the menu page
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    title: 'Domain name',
                    value: widget.domain,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    title: 'Username',
                    value: widget.username,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    title: 'Password Length',
                    value: widget.passwordLength.toString(),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    title: 'Version Number',
                    value: widget.versionNumber.toString(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 112),
            Center(
                child: SizedBox(
                    width: 300,
                    child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter User Key',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                    ),
                ),
            ),
            SizedBox(height: 16),
            Text(
              'Your secret personal key that is used to \n'
                  'generate all your passwords',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF938F99),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: 175.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showPassword = true;
                  });
                },
                child: Text(
                  'View Password',
                  style: TextStyle(
                    color: Color(0xFF4A4458),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(232, 222, 248, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_showPassword) ...[
              Text('Password: $_password'),
              SizedBox(height: 16),
            ],
            // Spacer(),
            SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: implement update password functionality
                    },
                    child: Text('Update Password',style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3B3B3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: implement delete account functionality
                    },
                    child: Text('Delete Account',style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFDC362E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 40),
           ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String value}) {
    return Card(
      elevation: 4,
      color: Color.fromRGBO(232, 222, 248, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
