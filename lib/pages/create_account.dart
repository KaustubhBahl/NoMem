import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

// final List<String> commonDomains = ['Google', 'Twitter', 'Facebook'];

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
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String? selectedOption;

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
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        // Use your own data source here to generate the autocomplete options
                        return [
                          'Google',
                          'Facebook',
                          'Twitter',
                        ].where((option) => option.toLowerCase().startsWith(textEditingValue.text.toLowerCase())).toList();
                      },
                      onSelected: (String selectedOption) {
                        setState(() {
                          // Update the selected option when the user selects an option
                          this.selectedOption = selectedOption;
                        });
                      },
                      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onChanged: (String value) {
                            setState(() {
                              // Update the selected option as the user types
                              selectedOption = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Option',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Option is a required field';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => onFieldSubmitted(),
                        );
                      },
                      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                        // Build the dropdown options from the generated list of autocomplete options
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Text(
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
                  Text(
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
                          controller: versionNumberController)),
                  Text(
                    "The version number of current password. You can update this later to update the password.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF938F99),
                    ),
                    textAlign: TextAlign.center,
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
                          controller: passwordLengthController)),
                  Text(
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
                          obscureText: _obscureText,
                          // obscuringCharacter: '*',
                          decoration: InputDecoration(
                            labelText: "User Key",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "eg. ab765418",
                            // hintStyle: const TextStyle(fontStyle:FontStyle.italic ),
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
                          controller: userKeyController)
                  ),
                  Text(
                    'Your secret personal key that is used to generate all your passwords',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF938F99),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!(_formKey.currentState!.validate())) {
                          return;
                        }

                        final domain = domainController.text.trim();
                        final username = usernameController.text.trim();
                        final passwordLength =
                            passwordLengthController.text.trim();
                        final versionNumber =
                            versionNumberController.text.trim();
                        final userKey = userKeyController.text.trim();

                        final directory =
                            await getApplicationDocumentsDirectory();
                        final db = File('${directory.path}/db.nomem');
                        if (db.existsSync() == false) {
                          db.create();
                        } else {
                          final contents = await db.readAsLines();
                          var i = 0;
                          while (i < contents.length) {
                            if (contents[i] == domain &&
                                contents[i + 1] == username) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Password for the account already exists',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }
                            i += 4;
                          }
                        }
                        final details =
                            "$domain\n$username\n$passwordLength\n$versionNumber\n";
                        await db.writeAsString(details, mode: FileMode.append);
                        userKeyController.clear();
                        domainController.clear();
                        usernameController.clear();
                        passwordLengthController.text = '12';
                        versionNumberController.text = '1';

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

                        final data =
                            '$details${userKeyController.text.trim()}\n';
                        var bytes = utf8.encode(data); // data being hashed
                        var digest = sha512.convert(bytes);
                        String digestHex = '$digest';
                        var i = 0;
                        var sum = 0;
                        var len = int.parse(passwordLength);
                        while (i < digestHex.length) {
                          sum += digestHex[i].codeUnitAt(0);
                          i++;
                        }
                        final password = digestHex.substring(0, len - 4) +
                            String.fromCharCode(sum % 15 + '!'.codeUnitAt(0)) +
                            String.fromCharCode(sum % 26 + 'A'.codeUnitAt(0)) +
                            String.fromCharCode(sum % 26 + 'a'.codeUnitAt(0)) +
                            String.fromCharCode(sum % 10 + '0'.codeUnitAt(0));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'The account details have been stored. Tap to copy the generated password.'),
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
                      child: Text(
                        'Generate Password',
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
                  const SizedBox(height: 20),
                ]),
          ),
        ),
      ),
    );
  }
}
