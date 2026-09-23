import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const dbFileName = 'kasirapp.sqlite';

/// Path file SQLite tunggal (1 toko, 1 device).
/// Dipakai connection + backup/restore agar tidak duplikasi logika.
Future<File> databaseFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, dbFileName));
}
