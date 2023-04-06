import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
  int update = 0;
  final userKeyController = TextEditingController();
  bool validateUserKey = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 251, 250, 1),
      appBar: AppBar(
        title: const Text(
          "Account Details",
          // style: TextStyle(textAlign: TextAlign.center),
          // style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(232, 222, 248, 1),
        foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
        // shadowColor: const Color.fromRGBO(255, 255, 255, 1),
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
                    value: (widget.versionNumber+update).toString(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 112),
            Center(
              child: SizedBox(
                width: 300,
                child: TextField(
                  obscureText: _obscureText,
                  controller: userKeyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Key',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: validateUserKey ? 'Please enter the user key' : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
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
                  if(userKeyController.text.trim().isEmpty) {
                   setState(() {validateUserKey = true;});
                   return;
                  }
                  final data = "${widget.domain}\n${widget.username}\n${widget.passwordLength}\n${widget.versionNumber+update}\n${userKeyController.text.trim()}\n";
                  var bytes = utf8.encode(data); // data being hashed
                  var digest = sha512.convert(bytes);
                  var digesthex = '$digest';
                  var i = 0;
                  var sum = 0;
                  var len = widget.passwordLength;
                  while(i<digesthex.length) {
                    sum += digesthex[i].codeUnitAt(0);
                    i++;
                  }
                  final password = digesthex.substring(0,len-4) + String.fromCharCode(sum%15+'!'.codeUnitAt(0)) + String.fromCharCode(sum%26+'A'.codeUnitAt(0)) + String.fromCharCode(sum%26+'a'.codeUnitAt(0)) + String.fromCharCode(sum%10+'0'.codeUnitAt(0));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Theme(
                        data: ThemeData(
                          dialogTheme: DialogTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: const Color.fromRGBO(255, 255, 245, 1),
                          ),
                        ),
                        child: AlertDialog(
                          title: Text(
                              'Tap the password to copy'),
                          content: GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: password));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Password copied to clipboard")),
                              );
                            },
                            child: Text(password),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(232, 222, 248, 1),
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
            SizedBox(height: 80),
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
                          return Theme(
                            data: ThemeData(
                              dialogTheme: DialogTheme(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: const Color.fromRGBO(255, 255, 245, 1),
                              ),
                            ),
                            child: AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                'Are you sure you want to update the password?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    final directory =
                                    await getApplicationDocumentsDirectory();
                                    final oldDB = File('${directory.path}/db.nomem');
                                    final newDB = File('${directory.path}/db_new.nomem');
                                    final contents = await oldDB.readAsLines();
                                    int i = 0;
                                    while (i < contents.length) {
                                      if (contents[i] == widget.domain &&
                                          contents[i + 1] == widget.username &&
                                          int.parse(contents[i + 2]) ==
                                              widget.passwordLength &&
                                          int.parse(contents[i + 3]) ==
                                              widget.versionNumber + update) {
                                        await newDB.writeAsString(
                                          '${contents[i]}\n${contents[i + 1]}\n${contents[i + 2]}\n${int.parse(contents[i + 3]) + 1}\n',
                                          mode: FileMode.append,
                                        );
                                      } else {
                                        await newDB.writeAsString(
                                          '${contents[i]}\n${contents[i + 1]}\n${contents[i + 2]}\n${contents[i + 3]}\n',
                                          mode: FileMode.append,
                                        );
                                      }
                                      i += 4;
                                    }
                                    await oldDB.delete();
                                    await newDB.rename('${directory.path}/db.nomem');
                                    setState(() {
                                      update += 1;
                                    });
                                    Fluttertoast.showToast(
                                      msg: "The password has been updated successfully",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
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
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF3B3B3B),
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
                          return Theme(
                            data: ThemeData(
                              dialogTheme: DialogTheme(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: const Color.fromRGBO(255, 255, 245, 1),
                              ),
                            ),
                            child: AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                'Are you sure you want to delete the account?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    final directory =
                                    await getApplicationDocumentsDirectory();
                                    final oldDB =
                                    File('${directory.path}/db.nomem');
                                    final newDB =
                                    File('${directory.path}/db_new.nomem');
                                    // newDB.openWrite();
                                    final contents = await oldDB.readAsLines();
                                    int i = 0;
                                    bool empty = true;
                                    while (i < contents.length) {
                                      if (contents[i] != widget.domain ||
                                          contents[i + 1] != widget.username) {
                                        await newDB.writeAsString(
                                            '${contents[i]}\n${contents[i + 1]}\n${contents[i + 2]}\n${contents[i + 3]}\n', mode: FileMode.append);
                                        empty = false;
                                      }
                                      i += 4;
                                    }
                                    await oldDB.delete();
                                    if(empty == true){
                                      newDB.writeAsString('');
                                    }
                                    await newDB.rename('${directory.path}/db.nomem');
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
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFDC362E),
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
