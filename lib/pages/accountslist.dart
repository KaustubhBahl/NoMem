import 'package:flutter/material.dart';
import 'package:nomem/pages/account_details.dart';
import 'package:nomem/model/account.dart';
import 'package:nomem/dbhelper.dart';

class CustomSearchDelegate extends SearchDelegate {

  final List<Account> accountsList;
  CustomSearchDelegate(this.accountsList);

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<Account> matchQuery = [];
    for (var fruit in accountsList) {
      if (fruit.domain.toLowerCase().contains(query.toLowerCase()) ||
          fruit.username.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Container(
          margin: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
          child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color.fromRGBO(103, 80, 164, 0.05),
                ),
                borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
              ),
              child: TextButton(
                onPressed: () {
                  close(context, null);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AccountDetailsPage(account: result)));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(103, 80, 164, 0.05)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                          leading: Image(
                            image: AssetImage('images/${result.icon}'),
                          ),
                          title: Text(result.domain,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              )),
                          subtitle: Text(result.username,
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.black)))
                    ]),
              )),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Account> matchQuery = [];
    for (var fruit in accountsList) {
      if (fruit.domain.toLowerCase().contains(query.toLowerCase()) ||
          fruit.username.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Container(
          margin: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
          child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color.fromRGBO(103, 80, 164, 0.05),
                ),
                borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
              ),
              child: TextButton(
                onPressed: () {
                  close(context, null);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AccountDetailsPage(account:result)));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(103, 80, 164, 0.05)),
                  //   // shadowColor: MaterialStateProperty.all(
                  //     const Color.fromRGBO(255, 255, 255, 1)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                          leading: Image(
                            image: AssetImage('images/${result.icon}'),
                          ),
                          title: Text(result.domain,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              )),
                          // const SizedBox(height: 8.0),
                          subtitle: Text(result.username,
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.black)))
                    ]),
              )),
        );
      },
    );
  }
}

class AccountsList extends StatefulWidget {
  const AccountsList({super.key});

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  // Future<List<Account>> fetchAccounts() async {
  //   List<Account> accounts = [];
  //   final directory = await getApplicationDocumentsDirectory();
  //   final db = File('${directory.path}/db.nomem');
  //   final contents = await db.readAsLines();
  //   int i = 0;
  //   while (i < contents.length) {
  //     accounts.add(Account(
  //         domain: contents[i],
  //         user: contents[i + 1],
  //         passwordLength: int.parse(contents[i + 2]),
  //         versionNumber: int.parse(contents[i + 3])));
  //     i += 4;
  //   }
  //   if(click) {
  //     if(ascendingSort) {
  //       accounts.sort((a, b) => (a.domain.compareTo(b.domain)));
  //     } else {
  //       accounts.sort((a, b) => (b.domain.compareTo(a.domain)));
  //     }
  //   }
  //   return accounts;
  // }

  Widget accountTemplate(account) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AccountDetailsPage(account:account)))
                  .then((_) => setState(() {}));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(103, 80, 164, 0.05)),
              //   // shadowColor: MaterialStateProperty.all(
              //     const Color.fromRGBO(255, 255, 255, 1)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                      leading: Image(
                        image: AssetImage('images/${account.icon}'),
                      ),
                      title: Text(account.domain,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          )),
                      // const SizedBox(height: 8.0),
                      subtitle: Text(account.user,
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.black)))
                ]),
          )),
    );
  }

  bool click = false;
  bool ascendingSort = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 251, 250, 1),
        appBar: AppBar(
          title: const Text(
            'Accounts',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
            showSearch(
            context: context,
            // delegate to customize the search bar
            delegate: CustomSearchDelegate(DBHelper().fetchAllAccounts()));
            },
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  click = true;
                  ascendingSort = !(ascendingSort);
                });
              },
              icon: const Icon(
                  Icons.sort_by_alpha,
                  color: Colors.black),
            ),
          ],
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(231, 224, 236, 1),
          foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: DBHelper().fetchAllAccounts().length,
          itemBuilder: (BuildContext context, int idx) {
              return accountTemplate(
                  DBHelper().fetchAllAccounts()[idx]);
          },
        ));
}}
