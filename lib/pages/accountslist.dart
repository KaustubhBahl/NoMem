import 'package:flutter/material.dart';

class Account {
  late String domain;
  late String user;
  late String icon1 = 'https://img.icons8.com/color/256/test-account.png';
  Account({required String domain,required String user, required String icon1}){
    this.domain = domain;
    this.user = user;
    this.icon1 = icon1;
  }
}

class AccountsList extends StatefulWidget{
  const AccountsList({super.key});

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  List<Account> accounts = [
    Account(domain: 'Facebook', user: 'billy@gmail.com', icon1: 'https://img.icons8.com/color/256/facebook-new.png'),
    Account(domain: 'Google', user: 'billy@gmail.com', icon1: 'https://img.icons8.com/color/256/google-logo.png'),
    Account(domain: 'SBI', user: 'billyjoel_951949', icon1: 'https://img.icons8.com/color/256/test-account.png'),
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
              color: Color.fromARGB(255,255,251,254),
            ),
            borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
          ),
          // margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0,8,8,8),
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
              )
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
        backgroundColor: const Color.fromARGB(255, 231,224,236),
      ),
      body: Column(
        children: accounts.map(
                (account) => accountTemplate(account, account.icon1)).toList(),
      )
    );
  }
}