import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomem/backup.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/nomem_home_logo.jpeg'),context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 250, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 150),
              Image.asset('assets/images/nomem_home_logo.jpeg', scale: 1.8),
              const SizedBox(height: 20),
              const Text('One stop solution to secure\npassword management',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
              const SizedBox(height: 100),
              IntrinsicWidth(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/addAccount');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(232, 222, 248, 1)),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 12),
                      child: Row(
                        children: const [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Generate new password',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/accountsList');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(232, 222, 248, 1)),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 12),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.visibility_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'View Password',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      var msg = await Import().import();
                      if(msg != 'Cancelled') {
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
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(232, 222, 248, 1)),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 12),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.file_upload,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Import accounts',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      var msg = '';
                      if (await Export().export()) {
                        msg = 'Data file exported to Download folder successfully';
                      } else {
                        msg = "Data wasn't exported as couldn't open Download folder";
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
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(232, 222, 248, 1)),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 12),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.file_download,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Export accounts',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          color: const Color.fromRGBO(103, 80, 164, 0.08),
          height: 70,
          child: const Center(
            child: Text(
              'MADE BY G5',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          )),
    );
  }
}
