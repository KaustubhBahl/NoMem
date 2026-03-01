import 'package:flutter/material.dart';
import 'package:nomem/dbhelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomem/passwordGen.dart';
import 'package:flutter/services.dart';
import 'package:nomem/backup.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => AddAccountState();
}

class AddAccountState extends State<AddAccount> {
  final usernameController = TextEditingController();
  final lengthController = TextEditingController(text: '12');
  final versionController = TextEditingController(text: '1');
  final userKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController domainController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = true;
  String? selectedOption;

  final List<String> _domainSuggestions = [
    "Google", "Facebook", "Twitter", "SBI", "Instagram",
    "LinkedIn", "Eduserver", "HDFC", "ICICI", "Aternos",
  ];

  @override
  void dispose() {
    usernameController.dispose();
    lengthController.dispose();
    versionController.dispose();
    userKeyController.dispose();
    domainController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export recommended'),
          content: const Text(
            'A new account has been added. Would you like to export the accounts onto your system?',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                var msg = '';
                Navigator.of(context).pop();
                if (await Export().export()) {
                  msg = 'Data file exported to Download folder successfully';
                } else {
                  msg = "Data wasn't exported as Download folder couldn't be opened";
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
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialog(BuildContext context, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Account stored!\nTap the icon to copy your password.',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            password,
                            style: const TextStyle(
                              fontFamily: 'Inconsolata',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: password));
                          Fluttertoast.showToast(
                            msg: 'Password copied to clipboard',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showExportDialog(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
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
                  child: RawAutocomplete<String>(
                    focusNode: _focusNode,
                    textEditingController: domainController,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return _domainSuggestions
                          .where((option) => option
                          .toLowerCase()
                          .startsWith(textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    onSelected: (String selectedOption) {
                      setState(() {
                        this.selectedOption = selectedOption;
                      });
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onChanged: (String value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Domain',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Google",
                          hintStyle: TextStyle(color: Colors.grey[350]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Domain is a required field';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => onFieldSubmitted(),
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 200,
                                maxWidth: 293,
                                minWidth: 293),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option =
                                options.elementAt(index);
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
                const Text(
                  "e.g. 'Facebook', 'Twitter', etc. No need to enter the complete URL.",
                  style: TextStyle(fontSize: 11, color: Color(0xFF938F99)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "example@abc.com",
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      errorMaxLines: 2,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is a required field';
                      }
                      return null;
                    },
                    controller: usernameController,
                  ),
                ),
                const Text(
                  "The unique login ID for your account.",
                  style: TextStyle(fontSize: 11, color: Color(0xFF938F99)),
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorMaxLines: 2,
                    ),
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value.trim()) == null ||
                          int.parse(value.trim()) < 1) {
                        return 'Version number must be a positive number';
                      }
                      return null;
                    },
                    controller: versionController,
                  ),
                ),
                const Text(
                  "When you update the password, this value increases. You may leave this as 1.",
                  style: TextStyle(fontSize: 11, color: Color(0xFF938F99)),
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorMaxLines: 2,
                    ),
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value.trim()) == null ||
                          int.parse(value.trim()) < 4 ||
                          int.parse(value.trim()) > 128) {
                        return 'Password length must be between 4 and 128';
                      }
                      return null;
                    },
                    controller: lengthController,
                  ),
                ),
                const Text(
                  "The length of the password",
                  style: TextStyle(fontSize: 11, color: Color(0xFF938F99)),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "User Key",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "eg. ab765418",
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    controller: userKeyController,
                  ),
                ),
                const Text(
                  'Your secret personal key that is used to generate all your passwords',
                  style: TextStyle(fontSize: 12, color: Color(0xFF938F99)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!(_formKey.currentState!.validate())) return;
                      if (selectedOption == null) return;

                      final domain = selectedOption!.trim();
                      final username = usernameController.text.trim();
                      final length = lengthController.text.trim();
                      final version = versionController.text.trim();
                      final userKey = userKeyController.text.trim();

                      if (!DBHelper().createAccount(domain, username,
                          int.parse(length), int.parse(version))) {
                        Fluttertoast.showToast(
                          msg: 'Password for the account already exists',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }

                      userKeyController.clear();
                      usernameController.clear();
                      lengthController.text = '12';
                      versionController.text = '1';
                      domainController.clear();
                      setState(() => selectedOption = null);

                      if (userKey.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'The account has been created.',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        _showExportDialog(context);
                      } else {
                        final password = PasswordGen(
                          domain: domain,
                          username: username,
                          length: length,
                          version: version,
                          userKey: userKey,
                        ).generatePassword();
                        _showPasswordDialog(context, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text('Generate Password'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}