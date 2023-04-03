import 'package:flutter/material.dart';
import 'package:nomem/pages/account_details.dart';

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
  List<Account> accounts = [
    Account.withIcon(domain: 'Facebook', user: 'billy@gmail.com', passwordLength: 12, versionNumber: 1, icon1: 'https://img.icons8.com/color/256/facebook-new.png'),
    Account.withIcon(domain: 'Google', user: 'billy@gmail.com', passwordLength: 16, versionNumber: 2, icon1: 'https://img.icons8.com/color/256/google-logo.png'),
    Account.withIcon(domain: 'SBI', user: 'billyjoel_951949', passwordLength: 12, versionNumber: 34, icon1: 'https://img.icons8.com/color/256/test-account.png'),
  ];

  List<String> icons = [
    'https://img.icons8.com/color/256/facebook-new.png',
    'https://img.icons8.com/color/256/google-logo.png',
  ];

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
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AccountDetailsPage(domain: account.domain, username: account.user, passwordLength: account.passwordLength, versionNumber: account.versionNumber)));},
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
      body: SingleChildScrollView(
        child: Column(
          children: accounts.map(
                  (account) => accountTemplate(account, account.icon1)).toList(),
        ),
      )
    );
  }
}