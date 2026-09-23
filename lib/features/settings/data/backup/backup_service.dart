import 'dart:io';
import 'dart:typed_data';

/// Validasi + salin file untuk restore. Murni dart:io — unit-testable.
class BackupService {
  const BackupService();

  /// Header SQLite: "SQLite format 3\0" (16 byte pertama).
  static const _magic = 'SQLite format 3\x00';

  bool isSqliteFile(Uint8List bytes) {
    if (bytes.length < 16) return false;
    final head = String.fromCharCodes(bytes.sublist(0, 16));
    return head == _magic;
  }

  /// Salin [source] ke [target] setelah validasi magic header.
  /// Melempar [FormatException] bila bukan file SQLite.
  Future<void> restoreDatabase({
    required File source,
    required File target,
  }) async {
    final bytes = await source.readAsBytes();
    if (!isSqliteFile(bytes)) {
      throw const FormatException('Bukan file database SQLite');
    }
    await source.copy(target.path);
  }
}
