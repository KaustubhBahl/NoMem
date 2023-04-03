import 'package:flutter/material.dart';

class Create_account_page extends StatefulWidget {
  const Create_account_page({super.key});

  @override
  State<Create_account_page> createState() => create_account_state();
}

class create_account_state extends State<Create_account_page> {
  void add_details() {
    //need to add details into backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 251, 250, 1),
      appBar: AppBar(
        title: const Text(
          "Create Account",
          textAlign: TextAlign.center,
          // style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(232, 222, 248, 1),
        foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
        // shadowColor: const Color.fromRGBO(255, 255, 255, 1),
      )
      ,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
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
            )),
        SizedBox(height: 16),
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
            )),
        SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: TextFormField(
              initialValue: '1',
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
              ),
            )),
        SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: TextFormField(
              initialValue: '12',
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
              ),
            )),
        SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: TextField(
              obscureText: true,
              obscuringCharacter: '*',
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
            )),
        SizedBox(height: 16),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: add_details,
            child: const Text("Submit", style: TextStyle(color: Colors.black)),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22))),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(232, 222, 248, 1)),
                shadowColor: MaterialStateProperty.all(Colors.black),
                elevation: MaterialStateProperty.all(12)),
          ),
        ),
      ],
        ),
      ),
    );
  }
}
