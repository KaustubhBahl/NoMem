import 'package:flutter/material.dart';

class AccountsList extends StatelessWidget{
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: <Widget>[
          IconButton(
            icon : Icon(Icons.search),
            onPressed: (){},
          ),
          IconButton(
            icon : Icon(Icons.sort_by_alpha,),
            onPressed: (){},
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(243,237,247,255),
      ),
    );
  }
}