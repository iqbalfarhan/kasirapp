import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Hub Setting: pintu masuk ke stack Menu, Pelanggan, Laporan,
/// Info Toko, Pajak, Pengguna, Backup (keputusan review: 3 tab).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _items = <({String title, String subtitle, String route})>[
    (
      title: 'Menu',
      subtitle: 'Produk, kategori, stok & jasa',
      route: '/setting/products',
    ),
    (
      title: 'Pelanggan',
      subtitle: 'Master data pelanggan',
      route: '/setting/customers',
    ),
    (
      title: 'Laporan',
      subtitle: 'Harian, mingguan, bulanan, tahunan, custom',
      route: '/setting/reports',
    ),
    (
      title: 'Info Toko',
      subtitle: 'Nama, alamat & telepon struk',
      route: '/setting/store',
    ),
    (
      title: 'Pajak & Diskon',
      subtitle: 'Pajak 0–100% & batas diskon',
      route: '/setting/tax',
    ),
    (
      title: 'Pengguna',
      subtitle: 'Admin & kasir, PIN & lockout',
      route: '/setting/users',
    ),
    (
      title: 'Backup',
      subtitle: 'Backup / restore database',
      route: '/setting/backup',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.subtitle, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            minVerticalPadding: 16,
            onTap: () => context.go(item.route),
          );
        },
      ),
    );
  }
}
