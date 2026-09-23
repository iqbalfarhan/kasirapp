import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/data/db_file.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/settings/data/backup/backup_service.dart';
import 'package:share_plus/share_plus.dart';

/// Backup (bagikan file sqlite) + restore (pilih file → timpa → restart).
class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _busy = false;
  static const _service = BackupService();

  Future<void> _backup() async {
    setState(() => _busy = true);
    try {
      final file = await databaseFile();
      final exists = await file.exists();
      if (!mounted) return;
      if (!exists) {
        showError(context, 'File database belum ada');
        return;
      }
      final size = await file.length();
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/x-sqlite3')],
        text: 'Backup Kasirapp (${(size / 1024).toStringAsFixed(1)} KB)',
      );
    } catch (e) {
      if (!mounted) return;
      showError(context, 'Gagal backup: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['sqlite', 'db'],
      withData: false,
    );
    if (picked == null || picked.files.single.path == null) return;
    if (!mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Database?'),
        content: const Text(
          'Data saat ini akan DITIMPA file backup. '
          'Setelah restore, tutup dan buka ulang aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _busy = true);
    try {
      // Tutup koneksi aktif sebelum menimpa file.
      await ref.read(databaseProvider).close();
      final target = await databaseFile();
      await _service.restoreDatabase(
        source: File(picked.files.single.path!),
        target: target,
      );
      if (!mounted) return;
      showOk(context, 'Restore berhasil. Restart aplikasi sekarang.');
    } on FormatException catch (e) {
      if (!mounted) return;
      showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      showError(context, 'Gagal restore: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Backup menyimpan salinan file database. Restore menimpa '
          'data saat ini — lakukan backup dulu bila ragu.',
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _busy ? null : _backup,
          icon: const Icon(Icons.backup),
          label: const Text('Backup Sekarang'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _busy ? null : _restore,
          icon: const Icon(Icons.restore),
          label: const Text('Restore dari File'),
        ),
        if (_busy) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
