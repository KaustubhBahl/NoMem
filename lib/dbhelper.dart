import 'dart:core';
import 'package:hive/hive.dart';
import 'package:nomem/model/account.dart';

class DBHelper {
  // fetches the box (table) of accounts
  static Box<Account> getAccountBox() => Hive.box<Account>('accounts');

  List<Account> fetchAllAccounts() => getAccountBox().values.toList();

  bool createAccount(String domain, String username, int length, int version) {
    // check if account is present
    List<Account> accounts = fetchAllAccounts();
    for (var account in accounts) {
      if (account.domain == domain && account.username == username) {
        return false;
      }
    }

    var icon = '';
    if(domain == 'Google') {
      icon = 'google-listicon.png';
    }
    else if (domain == 'Facebook') {
      icon = 'facebook-listicon.png';
    }
    else if (domain == 'Twitter') {
      icon = 'twitter-listicon.png';
    }
    else if (domain == 'SBI') {
      icon = 'sbi-listicon.png';
    }
    else if (domain == 'Instagram') {
      icon = 'instagram-listicon.png';
    }
    else if (domain == 'LinkedIn') {
      icon = 'linkedin-listicon.png';
    }
    else if (domain == 'Eduserver') {
      icon = 'eduserver-listicon.png';
    }
    else if (domain == 'HDFC') {
      icon = 'hdfc-listicon.png';
    }
    else if (domain == 'ICICI') {
      icon = 'icici-listicon.png';
    }
    else if (domain == 'Aternos') {
      icon = 'aternos-listicon.png';
    }
    else {
      icon = 'default-listicon.png';
    }

    // if no such account present, insert into the box with the key being domain+username
    final account = Account() // create the required account record
      ..domain = domain
      ..username = username
      ..length = length
      ..version = version;
      ..icon
    final accountBox = getAccountBox(); // get the box
    accountBox.add(account);
    return true;
  }

  Account? fetchAccountFromKey(String domain, String username) {
    List<Account> accounts = fetchAllAccounts();
    for (var account in accounts) {
      if (account.domain == domain && account.username == username) {
        return account;
      }
    }
    return null;
  }

  void updatePassword(String domain, String username) {
    // TODO: implement update password of an account
  }

  void deleteAccount(String domain, String username) {
    // TODO: implement delete account for an account
  }
}
