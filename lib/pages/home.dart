import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                      child: Text('Add a new account',
                          style: TextStyle(color: Colors.black)),
                    )),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                      child: Text('Manage an existing account',
                          style: TextStyle(color: Colors.black)),
                    )),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                      child: Text('Import accounts',
                          style: TextStyle(color: Colors.black)),
                    )),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                      child: Text('Export accounts',
                          style: TextStyle(color: Colors.black)),
                    )),
              ],
            )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          color: const Color.fromRGBO(103, 80, 164, 0.08),
          height: 70,
          child: const Center(
            child: Text('COPYRIGHT BY G5',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          )),
    );
  }
}
