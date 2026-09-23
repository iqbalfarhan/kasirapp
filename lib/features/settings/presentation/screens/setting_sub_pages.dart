import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/ui/snackbar.dart';
import 'package:kasirapp/features/settings/domain/entities/store_settings.dart';
import 'package:kasirapp/features/settings/presentation/providers/auth_providers.dart';

/// Form info toko. Pajak & batas diskon di TaxPage.
class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  bool _loaded = false;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save(StoreSettings current) async {
    final repo = ref.read(settingsRepositoryProvider);
    final result = await repo.saveStore(StoreSettings(
      storeName: _name.text,
      taxPercent: current.taxPercent,
      maxDiscountPercent: current.maxDiscountPercent,
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
    ));
    if (!mounted) return;
    switch (result) {
      case Success():
        ref.invalidate(settingsProvider);
        showOk(context, 'Info toko tersimpan');
      case FailureResult():
        showError(context, result.failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return settings.when(
      data: (s) {
        if (!_loaded) {
          _name.text = s.storeName;
          _address.text = s.address ?? '';
          _phone.text = s.phone ?? '';
          _loaded = true;
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _name,
              decoration:
                  const InputDecoration(labelText: 'Nama toko*'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _address,
              decoration:
                  const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phone,
              decoration:
                  const InputDecoration(labelText: 'Telepon'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _save(s),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Gagal memuat: $e')),
    );
  }
}

/// Pajak 0–100% & batas diskon. Hanya admin (dijaga router + widget).
class TaxPage extends ConsumerStatefulWidget {
  const TaxPage({super.key});

  @override
  ConsumerState<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends ConsumerState<TaxPage> {
  final _tax = TextEditingController();
  final _maxDisc = TextEditingController();
  bool _loaded = false;

  @override
  void dispose() {
    _tax.dispose();
    _maxDisc.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final repo = ref.read(settingsRepositoryProvider);
    final tax = int.tryParse(_tax.text.trim());
    final maxDisc = int.tryParse(_maxDisc.text.trim());
    if (!mounted) return;
    if (tax == null || maxDisc == null) {
      showError(context, 'Isi angka 0-100%');
      return;
    }
    final r1 = await repo.saveTax(tax);
    if (!mounted) return;
    if (r1 is FailureResult) {
      showError(context, r1.failure.message);
      return;
    }
    final r2 = await repo.saveMaxDiscount(maxDisc);
    if (!mounted) return;
    switch (r2) {
      case Success():
        ref.invalidate(settingsProvider);
        showOk(context, 'Pajak & batas diskon tersimpan');
      case FailureResult():
        showError(context, r2.failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(isAdminProvider)) {
      return const Center(child: Text('Hanya admin.'));
    }    final settings = ref.watch(settingsProvider);
    return settings.when(
      data: (s) {
        if (!_loaded) {
          _tax.text = s.taxPercent.toString();
          _maxDisc.text = s.maxDiscountPercent.toString();
          _loaded = true;
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _tax,
              decoration: const InputDecoration(
                  labelText: 'Pajak (%)', helperText: '0–100, default 10'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _maxDisc,
              decoration: const InputDecoration(
                labelText: 'Batas diskon (%)',
                helperText: '0 = tanpa batas, default 20',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Simpan'),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Gagal memuat: $e')),
    );
  }
}
