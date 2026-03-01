import 'package:flutter/material.dart';
import 'package:nomem/pages/account_details.dart';
import 'package:nomem/model/account.dart';
import 'package:nomem/dbhelper.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Account> accountsList;
  CustomSearchDelegate(this.accountsList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  List<Account> _getMatches() {
    return accountsList.where((account) {
      return account.domain.toLowerCase().contains(query.toLowerCase()) ||
          account.username.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Widget _buildAccountTile(BuildContext context, Account result) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: colorScheme.surfaceVariant,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountDetailsPage(account: result),
              ),
            );
          },
          child: ListTile(
            leading: Image(
              image: AssetImage('assets/images/${result.icon}'),
              width: 40,
              height: 40,
            ),
            title: Text(
              result.domain,
              style: TextStyle(
                fontSize: 16.0,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            subtitle: Text(
              result.username,
              style: TextStyle(
                fontSize: 12.0,
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matches = _getMatches();
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) => _buildAccountTile(context, matches[index]),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matches = _getMatches();
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) => _buildAccountTile(context, matches[index]),
    );
  }
}

class AccountsList extends StatefulWidget {
  const AccountsList({super.key});

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  List<Account> accounts = DBHelper().fetchAllAccounts();
  bool ascendingSort = false;

  void _precacheImages(BuildContext context) {
    for (final name in [
      'amazon-listicon.png',
      'facebook-listicon.png',
      'twitter-listicon.png',
      'sbi-listicon.png',
      'instagram-listicon.png',
      'linkedin-listicon.png',
      'eduserver-listicon.png',
      'hdfc-listicon.png',
      'icici-listicon.png',
      'aternos-listicon.png',
      'default-listicon.png',
      'google-listicon.png',
    ]) {
      precacheImage(AssetImage('assets/images/$name'), context);
    }
  }

  Widget _accountTile(BuildContext context, Account account) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: colorScheme.surfaceVariant,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountDetailsPage(account: account),
              ),
            ).then((_) => setState(() {
              accounts = DBHelper().fetchAllAccounts();
            }));
          },
          child: ListTile(
            leading: Image(
              image: AssetImage('assets/images/${account.icon}'),
              width: 40,
              height: 40,
            ),
            title: Text(
              account.domain,
              style: TextStyle(
                fontSize: 16.0,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            subtitle: Text(
              account.username,
              style: TextStyle(
                fontSize: 12.0,
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _precacheImages(context);
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Accounts'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(accounts),
              );
            },
          ),
          IconButton(
            icon: Icon(
              ascendingSort ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined,
            ),
            onPressed: () {
              setState(() {
                ascendingSort = !ascendingSort;
                accounts.sort((a, b) {
                  final domainCmp = ascendingSort
                      ? a.domain.toLowerCase().compareTo(b.domain.toLowerCase())
                      : b.domain.toLowerCase().compareTo(a.domain.toLowerCase());
                  if (domainCmp != 0) return domainCmp;
                  return ascendingSort
                      ? a.username.toLowerCase().compareTo(b.username.toLowerCase())
                      : b.username.toLowerCase().compareTo(a.username.toLowerCase());
                });
              });
            },
          ),
        ],
      ),
      body: accounts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No accounts yet',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Generate new password" on the home screen\nto add your first account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: accounts.length,
        itemBuilder: (BuildContext context, int idx) {
          return _accountTile(context, accounts[idx]);
        },
      ),
    );
  }
}