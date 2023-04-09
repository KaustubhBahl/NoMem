import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Export {
  Future<String> export () async {
    final DateTime now = DateTime.now();
    final filenameSuffix = '${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}';
    File exportedFile = File('/storage/emulated/0/Download/$filenameSuffix-data.nomem');
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File db = File('${appDocumentsDir.path}/accounts.hive');
    exportedFile.writeAsBytesSync(db.readAsBytesSync());
    return "Exported successfully";
  }
}

// class Import {
//   Futu
// }