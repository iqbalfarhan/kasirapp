import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kasirapp/main.dart' as app;

/// E2E (jalan di device/emulator via `flutter test integration_test`):
/// login → ganti PIN → tambah menu → jual tunai → jual QRIS →
/// riwayat → void → laporan exclude batal → stok kembali.
///
/// Catatan: memakai DB file asli device. Jalankan di profil/dataset uji.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E kasir penuh', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. Login admin seed + wajib ganti PIN.
    await tester.enterText(find.byType(TextField).first, '1234');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Ganti PIN'), findsOneWidget);
    final pinFields = find.byType(TextField);
    await tester.enterText(pinFields.at(0), '5678');
    await tester.enterText(pinFields.at(1), '5678');
    await tester.tap(find.text('Simpan PIN'));
    await tester.pumpAndSettle();
    expect(find.text('Kasir'), findsWidgets);

    // 2. Tambah menu via Setting → Menu.
    await tester.tap(find.text('Setting').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    final form = find.byType(TextField);
    await tester.enterText(form.at(0), 'Kopi E2E');
    await tester.enterText(form.at(1), 'Minuman');
    await tester.enterText(form.at(2), '10000');
    await tester.enterText(form.at(3), '5');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Kopi E2E'), findsOneWidget);

    // 3. Jual tunai di Kasir.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kasir').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kopi E2E'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Bayar').first);
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Nominal bayar (Rp)'), '15000');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Bayar').last);
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran Berhasil'), findsOneWidget);
    expect(find.textContaining('4.000'), findsOneWidget); // kembalian
    await tester.tap(find.text('Transaksi Baru'));
    await tester.pumpAndSettle();

    // 4. Jual QRIS (wajib pas 11.000).
    await tester.tap(find.text('Kopi E2E'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Bayar').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('QRIS'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Bayar Rp'));
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran Berhasil'), findsOneWidget);
    await tester.tap(find.text('Transaksi Baru'));
    await tester.pumpAndSettle();

    // 5. Riwayat: 2 transaksi → void yang pertama (tunai).
    await tester.tap(find.text('Riwayat').first);
    await tester.pumpAndSettle();
    expect(find.text('2 transaksi'), findsOneWidget);
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Void'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'uji e2e');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Void').last);
    await tester.pumpAndSettle();
    expect(find.text('BATAL'), findsOneWidget);

    // 6. Laporan: hanya QRIS yang dihitung (net 11.000, 1 trx).
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Setting').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsWidgets); // jumlah transaksi
    expect(find.textContaining('Rp 11.000'), findsWidgets);

    // 7. Stok kembali 5 (5-1-1+1).
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Stok 5'), findsOneWidget);
  });
}
