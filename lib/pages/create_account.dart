import 'package:flutter/material.dart';
import 'package:nomem/dbhelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomem/passwordGen.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => AddAccountState();
}

class AddAccountState extends State<AddAccount> {
  final domainController = TextEditingController();
  final usernameController = TextEditingController();
  final lengthController = TextEditingController(text: '12');
  final versionController = TextEditingController(text: '1');
  final userKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    domainController.dispose();
    usernameController.dispose();
    lengthController.dispose();
    versionController.dispose();
    userKeyController.dispose();
    super.dispose();
  }

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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Domain",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Google",
                            errorMaxLines: 2,
                            // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Domain is a required field';
                            }
                            return null;
                          },
                          controller: domainController)),
                  // const SizedBox(height: 10),
                  const Text(
                    "e.g. 'Facebook', 'Twitter' ,etc. No need to enter complete URL.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF938F99),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TextFormField(
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
                            errorMaxLines: 2,
                            // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Username is a required field';
                            }
                            return null;
                          },
                          controller: usernameController)),
                  const Text(
                    "The unique login ID for your account.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF938F99),
                    ),
                    textAlign: TextAlign.justify,
                  ),
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
                            errorMaxLines: 2,
                            hintText: "1",
                            // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                int.tryParse(value.trim()) == null ||
                                int.parse(value.trim()) < 1) {
                              return 'Version number must be a positive number';
                            }
                            return null;
                          },
                          controller: versionController)),
                  const Text(
                    "The version number of current password. You \n can update this later to update the password.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF938F99),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Password Length",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "12",
                            errorMaxLines: 2,
                            // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                int.tryParse(value.trim()) == null ||
                                int.parse(value.trim()) < 1 ||
                                int.parse(value.trim()) > 128) {
                              return 'Password length must be between 1 and 128';
                            }
                            return null;
                          },
                          controller: lengthController)),
                  const Text(
                    "The length of the password",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF938F99),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TextFormField(
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
                          controller: userKeyController)),
                  const Text(
                    'Your secret personal key that is used to generate all your passwords',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF938F99),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 165,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!(_formKey.currentState!.validate())) {
                          return;
                        }

                        final domain = domainController.text.trim();
                        final username = usernameController.text.trim();
                        final length = lengthController.text.trim();
                        final version = versionController.text.trim();
                        final userKey = userKeyController.text.trim();

                        if (DBHelper().createAccount(domain, username,
                            int.parse(length), int.parse(version))) {
                          userKeyController.clear();
                          domainController.clear();
                          usernameController.clear();
                          lengthController.text = '12';
                          versionController.text = '1';
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Password for the account already exists',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }

                        if (userKey.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'The account has been created.',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }

                        String password = PasswordGen(
                                domain: domain,
                                username: username,
                                length: length,
                                version: version,
                                userKey: userKey)
                            .generatePassword();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                  'The account details have been stored. Tap to copy the generated password.'),
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
                        'Generate Password',
                        style: TextStyle(
                          color: Color(0xFF4A4458),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
