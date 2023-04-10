import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:nomem/dbhelper.dart';
import 'package:nomem/model/account.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Export {
  Future<bool> export() async {
    final DateTime now = DateTime.now();
    final filenameSuffix =
        '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-${now.second}';
    try {
      File('storage/emulated/0/Download/$filenameSuffix-data.nomem').createSync(recursive: true);
    } catch (e) {
      return false;
    }
    File db = File(DBHelper.getAccountBox().path!);
    File('storage/emulated/0/Download/$filenameSuffix-data.nomem').writeAsBytesSync(db.readAsBytesSync(), flush: true);
    return true;
  }
}

class Import {
  Future<bool> import() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null ||
        result.files.single.name.endsWith('.nomem') == false) {
      return false;
    } else {
      const secureStorage = FlutterSecureStorage();
      final key = await secureStorage.read(key: 'key');
      final encryptionKeyUint8List = base64Url.decode(key!);
      Box<Account> tempDB = await Hive.openBox<Account>('temp',
          encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
      final tempDBPath = tempDB.path;
      await tempDB.close();
      File(result.files.single.path!).copySync(tempDBPath!);
      tempDB = await Hive.openBox<Account>('temp', encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
      final List<Account> currentAccounts = DBHelper().fetchAllAccounts();
      final List<Account> importingAccounts = tempDB.values.toList();

      for (var importingAccount in importingAccounts) {
        bool flag = false;
        for (var currentAccount in currentAccounts) {
          if (importingAccount.domain == currentAccount.domain &&
              importingAccount.username == currentAccount.domain) {
            flag = true;
            break;
          }
        }
        if (!flag) {
          DBHelper().createAccount(
              importingAccount.domain,
              importingAccount.username,
              importingAccount.length,
              importingAccount.version);
          currentAccounts.add(importingAccount);
        }
      }
      tempDB.deleteFromDisk();
      return true;
    }
  }
}
