import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:nomem/dbhelper.dart';
import 'package:nomem/model/account.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Export {
  Future<bool> export () async {
    final DateTime now = DateTime.now();
    final filenameSuffix = '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-${now.second}';
    final dirPath = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select folder to export to: ');
    if(dirPath != null) {
      final exportedFile = File('$dirPath/$filenameSuffix-data.nomem');
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      File db = File('${appDocumentsDir.path}/accounts.hive');
      exportedFile.writeAsBytesSync(db.readAsBytesSync());
      return true;
    }
    return false;
  }
}

class Import {

  Future<bool> import() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['nomem']);
    if (result == null) {
      return false;
    } else {
      const secureStorage = FlutterSecureStorage();
      final key = await secureStorage.read(key: 'key');
      final encryptionKeyUint8List = base64Url.decode(key!);
      final tempDB = await Hive.openBox<Account>(
          'temp', encryptionCipher: HiveAesCipher(encryptionKeyUint8List));

      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      File db = File('${appDocumentsDir.path}/temp.hive');
      File importingFile = File(result.files.single.path!);
      db.writeAsBytesSync(importingFile.readAsBytesSync());

      final List<Account> currentAccounts = DBHelper().fetchAllAccounts();
      final List<Account> importingAccounts = tempDB.values.toList();
      for (var importingAccount in importingAccounts) {
        bool flag = false;
        for(var currentAccount in currentAccounts) {
          if(importingAccount.domain == currentAccount.domain && importingAccount.username == currentAccount.domain) {
            flag = true;
            break;
          }
        }
        if(!flag) {
          DBHelper().createAccount(importingAccount.domain, importingAccount.username, importingAccount.length, importingAccount.version);
        }
      }
      tempDB.deleteFromDisk();
      return true;
    }
  }
}