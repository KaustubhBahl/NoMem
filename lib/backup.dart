import 'dart:io';
import 'package:nomem/dbhelper.dart';
import 'package:nomem/model/account.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class Export {
  Future<bool> export() async {
    final DateTime now = DateTime.now();
    final filenameSuffix =
        '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-${now.second}';
    try {
      Directory? downloadsDir = await getExternalStorageDirectory();
      String downloadPath = '/storage/emulated/0/Download';
      final file = File('$downloadPath/$filenameSuffix-data.nomem');
      await file.create(recursive: true);
      List<Account> accounts = DBHelper().fetchAllAccounts();
      for (Account account in accounts) {
        await file.writeAsString(
          '${account.domain}\n${account.username}\n${account.length}\n${account.version}\n${account.icon}\n',
          mode: FileMode.append,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Import {
  Future<String> import() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) {
      return 'Cancelled';
    } else if (result.files.single.name.endsWith('.nomem') == false) {
      return "Data wasn't imported as selected file format is unsupported";
    } else {
      final List<Account> currentAccounts = DBHelper().fetchAllAccounts();
      List<String> content =
      File(result.files.single.path!).readAsLinesSync();
      if (content.length % 5 != 0) {
        return "Data wasn't imported as the selected file is corrupted";
      }

      List<String> icons = [
        'default-listicon.png',
        'aternos-listicon.png',
        'icici-listicon.png',
        'hdfc-listicon.png',
        'eduserver-listicon.png',
        'linkedin-listicon.png',
        'instagram-listicon.png',
        'sbi-listicon.png',
        'twitter-listicon.png',
        'facebook-listicon.png',
        'google-listicon.png'
      ];

      for (int i = 0; i < content.length; i += 5) {
        bool flag = false;
        if (content[i].isNotEmpty &&
            content[i + 1].isNotEmpty &&
            int.tryParse(content[i + 2]) != null &&
            int.tryParse(content[i + 3]) != null &&
            content[i + 4].isNotEmpty &&
            icons.contains(content[i + 4])) {
          for (var currentAccount in currentAccounts) {
            if (content[i] == currentAccount.domain &&
                content[i + 1] == currentAccount.username) {
              flag = true;
              break;
            }
          }
          if (!flag) {
            DBHelper().createAccount(
                content[i],
                content[i + 1],
                int.parse(content[i + 2]),
                int.parse(content[i + 3]));
            currentAccounts.add(Account()
              ..domain = content[i]
              ..username = content[i + 1]
              ..length = int.parse(content[i + 2])
              ..version = int.parse(content[i + 3])
              ..icon = content[i + 4]);
          }
        }
      }
      return 'All the valid data was imported successfully';
    }
  }
}