import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomem/passwordGen.dart';
import 'package:nomem/dbhelper.dart';
import 'package:nomem/model/account.dart';

class AccountDetailsPage extends StatefulWidget {
  final Account account;
  const AccountDetailsPage({
    Key? key,
    required this.account
  }) : super(key: key);

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  int update = 0;
  final userKeyController = TextEditingController();
  bool validateUserKey = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 250, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(232, 222, 248, 1),
        centerTitle: true,
        title: const Text(
          'Account Details',
          style: TextStyle(
            color: Color(0xFF1C1B1F),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF49454F)),
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
                    value: widget.account.domain,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    title: 'Username',
                    value: widget.account.username,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    title: 'Password Length',
                    value: widget.account.length.toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    title: 'Version Number',
                    value: widget.account.version.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 112),
            Center(
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: userKeyController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'User Key',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: validateUserKey ? 'Please enter the user key' : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your secret personal key that is used to \n'
              'generate all your passwords',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF938F99),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 175.0,
              child: ElevatedButton(
                onPressed: () {
                  if(userKeyController.text.trim().isEmpty) {
                   setState(() {validateUserKey = true;});
                   return;
                  }
                  final password = PasswordGen(domain: widget.account.domain, username: widget.account.username, length: widget.account.length.toString(), version: widget.account.version.toString(), userKey: userKeyController.text.trim()).generatePassword();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Tap the password to copy.'),
                        content: Text(password),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  // primary: const Color.fromRGBO(232, 222, 248, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  'View Password',
                  style: TextStyle(
                    color: Color(0xFF4A4458),
                  ),
                ),
              ),
            ),
            // Spacer(),
            const SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        validateUserKey = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content: const Text(
                                'Are you sure you want to update the password?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  DBHelper().updatePassword(widget.account.domain, widget.account.username);
                                  setState(() {
                                    update+=1;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                          "The password has been updated successfully",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: const Color(0xFF3B3B3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text('Update Password',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content: const Text(
                                'Are you sure you want to delete the account?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  DBHelper().deleteAccount(widget.account.domain, widget.account.username);
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                      msg:
                                      "The account has been deleted successfully",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: const Color(0xFFDC362E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text('Delete Account',
                        style: TextStyle(fontSize: 12)),
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
      // shadowColor: Color.fromRGBO(255, 255, 255, 1),
      color: const Color.fromRGBO(232, 222, 248, 1),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}