import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'dart:convert';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => AddAccountState();
}

class AddAccountState extends State<AddAccount> {
  final domainController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordLengthController = TextEditingController(text: '12');
  final versionNumberController = TextEditingController(text: '1');
  final userKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 250, 1),
      appBar: AppBar(
        title: const Text(
          "Create Account",
          // style: TextStyle(textAlign: TextAlign.center),
          // style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(232, 222, 248, 1),
        foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
        // shadowColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                        decoration: InputDecoration(
                          labelText: "Website",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "gmail",
                          // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                        ),
                        controller: domainController)
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "example@abc.com",
                          // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                        ),
                        controller: usernameController)),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Version Number",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "eg.12 or any positive number",
                          // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                        ), controller: versionNumberController)
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Length",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "eg.16 , the length of the password",
                          // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                        ), controller: passwordLengthController)
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                        obscureText: true,
                        // obscuringCharacter: '*',
                        decoration: InputDecoration(
                          labelText: "User key",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "eg. ab765418",
                          // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                        ),
                        controller: userKeyController
                    )),
                const SizedBox(height: 16),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      final directory = await getApplicationDocumentsDirectory();
                      final file = File('${directory.path}/db.nomem');
                      final data = "$domainController.text\n $usernameController.text\n $passwordLengthController.text\n $versionNumberController.text\n";
                      await file.writeAsString(data);
                      var bytes = utf8.encode(data); // data being hashed
                      var digest = sha512.convert(bytes);
                      var digesthex = '$digest';
                      var i = 0;
                      var sum = 0;
                      var len = int.parse(passwordLengthController.text);
                      while(i<digesthex.length) {
                        sum += digesthex[i].codeUnitAt(0);
                        i++;
                      }
                      final password = digesthex.substring(0,len-4) + String.fromCharCode(sum%15+'!'.codeUnitAt(0)) + String.fromCharCode(sum%26+'A'.codeUnitAt(0)) + String.fromCharCode(sum%26+'a'.codeUnitAt(0)) + String.fromCharCode(sum%10+'0'.codeUnitAt(0));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('The account details have been stored. Tap to copy the generated password.'),
                            content: Text(password),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Generate Password'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }}
