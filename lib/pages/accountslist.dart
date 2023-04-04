import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nomem/pages/account_details.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Account {
  final String domain;
  final String user;
  final int passwordLength;
  final int versionNumber;
  String icon1 = 'https://img.icons8.com/color/256/test-account.png';

  Account({
    Key? key,
    required this.domain,
    required this.user,
    required this.passwordLength,
    required this.versionNumber,
  });

  Account.withIcon({
    Key? key,
    required this.domain,
    required this.user,
    required this.passwordLength,
    required this.versionNumber,
    required this.icon1
  });
}

class AccountsList extends StatefulWidget{
  const AccountsList({super.key});

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  Future<List<Account>> fetchAccounts() async {
    List<Account> accounts = [];
    final directory = await getApplicationDocumentsDirectory();
    final db = File('${directory.path}/db.nomem');
    final contents = await db.readAsLines();
    int i = 0;
    while(i<contents.length) {
      accounts.add(Account(domain: contents[i],
          user: contents[i + 1],
          passwordLength: int.parse(contents[i + 2]),
          versionNumber: int.parse(contents[i + 3])));
      i += 4;
    }
    return accounts;
  }
  Widget accountTemplate(account, String i){
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
      // decoration: const BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       blurRadius: 10.0,
      //     ),
      //   ],
      // ),
      child: Card(
        elevation: 3,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromRGBO(103, 80, 164, 0.05),
            ),
            borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
          ),
          // margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: TextButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AccountDetailsPage(domain: account.domain, username: account.user, passwordLength: account.passwordLength, versionNumber: account.versionNumber))).then((_) => setState(() {}));},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(103, 80, 164, 0.05)),
            //   // shadowColor: MaterialStateProperty.all(
              //     const Color.fromRGBO(255, 255, 255, 1)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(leading: Image(
                    image: NetworkImage(i),
                  ),
                  title: Text(
                      account.domain,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      )
                  ),
                  // const SizedBox(height: 8.0),
                  subtitle: Text(
                      account.user,
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black
                      )
                  )
                  )]
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 251, 250, 1),
        appBar: AppBar(
        title: const Text('Accounts',
                        style: TextStyle(color: Colors.black),
                      ),
        actions: <Widget>[
          IconButton(
            icon : Icon(Icons.search,color: Colors.black,),
            onPressed: (){},
          ),
          IconButton(
            icon : Icon(Icons.sort_by_alpha,color: Colors.black,),
            onPressed: (){},
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(231, 224, 236, 1),
        foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
      ),
      body: FutureBuilder(
          future: fetchAccounts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              itemBuilder: (BuildContext context, int idx) {
                if (snapshot.data != null) {
                  return accountTemplate(snapshot.data[idx], snapshot
                      .data[idx].icon1);
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          })
    );
  }
}