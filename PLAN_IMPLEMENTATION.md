# PLAN IMPLEMENTATION — Kasirapp POS

> 1 toko lokal • Offline penuh (SQLite/Drift) • IDR + Pajak adjustable (default 10%) • Struk PDF • Responsive HP + Tablet • Fulltest

## 0. Ringkasan Keputusan

| Aspek | Keputusan |
|---|---|
| Toko | 1 toko, 1 device, tanpa sync/cloud |
| Storage | Lokal saja: `drift` + `sqlite3_flutter_libs` |
| Mata uang | Selalu IDR (`Rp 15.000`, tanpa desimal) |
| Pajak | Persen adjustable di Settings, **range 0–100%**, default 10%, dihitung setelah diskon, **snapshot per struk** (transaksi lama tidak berubah) |
| Stok | Barang lacak stok, **jasa (`track_stock=0`) bebas stok** — tidak dikurangi & tidak diblokir |
| Non-tunai | QRIS/transfer **wajib uang pas** (`bayar == total`, kembalian 0) |
| Diskon | Ganda: per-item (%/Rp) + per-struk (%/Rp), **dibatasi `max_discount_percent`** (atur admin, default 20%, 0 = tanpa batas) |
| Void | Hanya admin + **wajib alasan**, simpan `void_reason/void_by/void_at` sebagai audit |
| Struk | PDF dulu (share/print via OS), tanpa thermal/Bluetooth di MVP |
| Client | Master Pelanggan terpisah + Riwayat Transaksi terpisah |
| User | Multi-user PIN: `admin` & `kasir`. PIN 4–6 digit angka, simpan hash (SHA-256+salt), lockout 5x salah → kunci 5 menit |
| Navigasi | HP: BottomNav 3 tab (Kasir, Riwayat, Setting) • Tablet ≥600dp: NavigationRail 3 item + 2-panel. Menu, Pelanggan, Laporan, Users, Backup di-stack dalam hub Setting |
| State / Route | `flutter_riverpod` + `go_router` |
| Laporan | Hari ini, Mingguan (Senin–Minggu), Bulanan, Tahunan, Custom range + grafik + export PDF/CSV |
| Testing | Unit + Widget + Integration, target `flutter analyze` bersih |

## 1. Aturan Hitung Resmi (Single Source of Truth)

Semua perhitungan ada di `lib/features/pos/domain/usecases/calculate_total.dart` sebagai UseCase murni (pure Dart, tanpa Flutter/Drift) agar 100% unit-testable. UI hanya memanggil usecase, tidak menghitung sendiri.

```
subtotal_kotor       = Σ (qty × harga_satuan)
diskon_item_total    = Σ diskon per-line (% atau Rp, clamp ≤ line total)
subtotal_bersih_item = subtotal_kotor − diskon_item_total
diskon_struk         = % atau Rp dari subtotal_bersih_item (clamp ≤ subtotal_bersih_item)
subtotal_setelah_diskon = subtotal_bersih_item − diskon_struk
pajak                = round(subtotal_setelah_diskon × pajak_persen / 100)
TOTAL                = subtotal_setelah_diskon + pajak  (clamp ≥ 0)
kembalian            = bayar − TOTAL  (tolak jika bayar < TOTAL)
```

Aturan tambahan:
1. Diskon item dihitung dulu, baru diskon struk, terakhir pajak.
2. Stok berkurang hanya saat transaksi sukses commit (dalam 1 transaksi DB). Gagal = rollback penuh. **Produk jasa (`track_stock=0`) tidak cek & tidak kurangi stok.**
3. Void/refund hanya admin **+ wajib alasan**, soft-delete (`status='batal'` + `void_reason/void_by/void_at`), stok barang dikembalikan (jasa tidak), laporan exclude batal, riwayat tetap tampil dengan badge.
4. `created_at` simpan sebagai epoch millis UTC; tampil format WIB via `intl` (`id_ID`).
5. Pembulatan IDR: `round()` ke rupiah penuh, tidak ada sen.
6. **Non-tunai (qris/transfer) wajib uang pas**: `bayar == total`, kembalian 0. Tunai: `bayar >= total`, tolak jika kurang.
7. **Batas diskon**: persen diskon item & struk tidak boleh melebihi `max_discount_percent` (0 = tanpa batas). Diskon amount (Rp) selalu boleh selama ≤ basisnya. Pelanggaran = `ValidationFailure`.
8. **Snapshot struk**: `pajak_persen/nilai`, `diskon_*`, `harga_snapshot/nama_snapshot` disimpan per transaksi dan tidak berubah saat master/settings berubah.

## 2. Skema Database (Drift v1)

```text
products(id TEXT PK, nama TEXT, kategori TEXT, harga INTEGER, stok INTEGER, track_stock INTEGER [0|1, default 1], gambar_path TEXT?, is_active INTEGER, created_at INTEGER, updated_at INTEGER)
customers(id TEXT PK, nama TEXT, hp TEXT?, alamat TEXT?, created_at INTEGER)
users(id TEXT PK, nama TEXT, pin_hash TEXT, pin_salt TEXT, role TEXT [admin|kasir], is_active INTEGER, must_change_pin INTEGER [0|1], failed_attempts INTEGER default 0, locked_until INTEGER?)
settings(key TEXT PK, value TEXT)  // keys: store_name, tax_percent (default 10), max_discount_percent (default 20, 0=tanpa batas), store_address, store_phone
transactions(id TEXT PK, customer_id TEXT? FK, kasir_id TEXT FK, subtotal INTEGER, diskon_item INTEGER, diskon_struk_tipe TEXT [none|percent|amount], diskon_struk_nilai INTEGER, pajak_persen INTEGER, pajak_nilai INTEGER, total INTEGER, bayar INTEGER, kembalian INTEGER, metode TEXT [tunai|qris|transfer], status TEXT [sukses|batal], void_reason TEXT?, void_by TEXT?, void_at INTEGER?, created_at INTEGER)
transaction_items(id TEXT PK, transaction_id TEXT FK, product_id TEXT FK, nama_snapshot TEXT, harga_snapshot INTEGER, qty INTEGER, diskon_tipe TEXT, diskon_nilai INTEGER, subtotal INTEGER)
```

Index: `transactions(created_at)`, `transaction_items(transaction_id)`, `products(kategori, is_active)`.
Migrasi: versioned (`schemaVersion = 1`), siapkan `migration_test` sejak awal.

## 3. Arsitektur — Full Clean Architecture Seragam (Feature-First)

> Keputusan: **full clean untuk semua fitur**. Pola seragam `domain / data / presentation` per fitur.
> Aturan dependency: `presentation → domain ← data`. Domain murni Dart, tanpa Flutter/Drift/Riverpod.

```
lib/
  main.dart                 // bootstrap + DI wiring + seed admin
  app.dart
  router.dart               // GoRouter StatefulShellRoute 3 cabang (kasir/riwayat/setting) + sub-routes setting + guard role
  core/
    error/failures.dart     // Failure, ValidationFailure, NotFoundFailure, ...
    result/result.dart      // Result<T> Success/Failure wrapper
    usecase/usecase.dart    // abstract UseCase<T, Params> + NoParams
    theme.dart
    responsive.dart
    money.dart              // formatRp(), parseRp()
    period.dart             // dipakai reports/domain
    receipt_pdf.dart        // dipakai transactions/reports via usecase Export
  features/
    pos/
      domain/entities/ (cart.dart, cart_item.dart, discount.dart, checkout_result.dart)
      domain/repositories/pos_repository.dart      // interface
      domain/usecases/ (calculate_total.dart, checkout.dart) // checkout bawa maxDiscountPercent, selaras dengan calculate
      data/models/ (cart_model.dart)
      data/datasources/ (pos_local_datasource.dart) // TODO drift Fase 2
      data/repositories/pos_repository_impl.dart
      presentation/screens/pos_screen.dart
      presentation/widgets/ (cart_panel.dart, checkout_sheet.dart)
      presentation/providers/ (cart_provider.dart) // TODO riverpod Fase 2
    products/
      domain/entities/product.dart // kategori kosong -> "Lainnya", jasa abaikan stok
      domain/repositories/product_repository.dart // tanpa hapus permanen: get/save/toggleActive
      domain/usecases/ (get_products.dart, save_product.dart, toggle_product_active.dart)
      data/... (mirror pos)
      presentation/... // diakses via Setting hub (/setting/products)
    customers/
      domain/entities/customer.dart
      domain/repositories/customer_repository.dart
      domain/usecases/ (get_customers.dart, save_customer.dart)
      data/...  presentation/... // via /setting/customers
    transactions/           // tab Riwayat + void + struk ulang
      domain/entities/transaction.dart (+ transaction_item.dart)
      domain/repositories/transaction_repository.dart
      domain/usecases/ (get_transactions.dart, void_transaction.dart) // void: admin + alasan wajib
      data/...  presentation/screens/ (history_list, history_detail)
    reports/
      domain/entities/report_summary.dart
      domain/repositories/report_repository.dart
      domain/usecases/get_report.dart   // pakai core/period.dart
      data/...  presentation/screens/report_screen.dart (+ chart widget) // via /setting/reports
    settings/               // tab Setting (hub): store, tax, products, customers, reports, users, backup
      domain/entities/ (store_settings.dart, app_user.dart) // app_user: failedAttempts/lockedUntil/mustChangePin
      domain/repositories/ (settings_repository.dart, user_repository.dart)
      domain/usecases/ (get_settings.dart, save_tax.dart, login_with_pin.dart) // login: format 4-6 digit + cek lockout
      data/...  presentation/...
test/
  unit/ (pos/calculate_total_test.dart, reports/period_test.dart, core/money_test.dart)
  widget/ ...
integration_test/app_test.dart
```

**Contoh acuan (sudah dibuat di skeleton):**
* `features/pos/domain/usecases/calculate_total.dart` — implementasi §1, pure, tanpa dependensi framework.
* `features/pos/domain/repositories/pos_repository.dart` + `data/repositories/pos_repository_impl.dart` — pola interface + impl yang dicopy ke semua fitur.
* Setiap fitur wajib punya minimal 1 entity + 1 repository interface + 1 usecase + 1 impl + 1 screen placeholder.

## 4. Dependensi (tambah ke pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod: ^2.5.0
  go_router: ^14.0.0
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.6.0+eol  // resolved 0.6.0+eol (terbaru kompatibel, drift 2.35)
  crypto: ^3.0.0  // hash PIN admin seed
  path_provider: ^2.1.0
  path: ^1.9.0
  intl: ^0.19.0
  uuid: ^4.4.0
  pdf: ^3.10.0
  printing: ^5.12.0
  share_plus: ^10.0.0
  fl_chart: ^0.68.0
dev_dependencies:
  drift_dev: ^2.20.0
  build_runner: ^2.4.0
  mocktail: ^1.0.0
  integration_test: {sdk: flutter}
```

## 5. Strategi Responsive

* Helper `isTablet = shortestSide >= 600`.
* HP: `BottomNavigationBar` 3 tab (Kasir, Riwayat, Setting); Menu/Pelanggan/Laporan/Users/Backup dibuka dari hub Setting (stack). POS vertikal + keranjang sebagai `BottomSheet` + `DraggableScrollableSheet`.
* Tablet: `NavigationRail` kiri + POS split `Row(flex 3: grid menu, flex 2: cart sticky)`, tabel riwayat/laporan lebih lebar.
* Grid menu: HP 2 kolom, tablet 3–4 kolom (`SliverGrid` + `LayoutBuilder`).
* Semua tombol aksi kasir min 48dp, support rotasi + font besar (test `textScaleFactor 1.3`).

## 6. FASE IMPLEMENTASI

### FASE 0 — Fondasi (estimasi 1–2 hari)
- [ ] Setup dependensi + `flutter pub get` + `build_runner` jalan
- [ ] `core/theme.dart`, `responsive.dart`, `money.dart`, `period.dart` + domain POS `calculate_total.dart`
- [ ] Drift DB + DAO + `settings` default (store_name, tax_percent=10, max_discount_percent=20)
- [ ] `app.dart` + `router.dart` (StatefulShellRoute 3 cabang + sub-routes setting) + 3 halaman placeholder
- [ ] Seed admin default (PIN `1234` di-hash + salt, flag `must_change_pin=1`)
- **Acceptance:** app jalan HP+tablet, `flutter analyze` bersih, DB terbuat tanpa crash.

### FASE 1 — Master: Produk, Pelanggan, User (2–3 hari)
- [ ] Produk: nama, kategori (kosong → "Lainnya"), harga, stok + flag jasa (`track_stock`), foto lokal (path), aktif/nonaktif, search + filter kategori. **Tanpa hapus permanen** — produk yang pernah terjual hanya boleh dinonaktifkan (tombol hapus disembunyikan/disable).
- [ ] Stok stepper + validasi (harga > 0, stok ≥ 0, jasa bebas stok)
- [ ] Pelanggan CRUD + pilih opsional di POS
- [ ] User CRUD + login PIN (hash, format 4–6 digit, lockout 5x → 5 menit, `must_change_pin`) + guard: kasir ❌ void/edit pajak/user
- **Acceptance:** tambah 50 produk dummy scroll lancar, nonaktifkan produk hilang dari POS tapi tetap di laporan lama.

### FASE 2 — POS / Kasir (3–4 hari, inti)
- [ ] Cart provider: tambah/kurang/qty, snapshot harga, diskon per-line
- [ ] Checkout sheet: diskon struk (%/Rp), preview pajak live, pelanggan opsional, metode bayar, nominal cepat (Uang pas/10k/20k/50k/100k), input bayar + kembalian live
- [ ] Validasi: stok tidak cukup diblokir (kecuali jasa), diskon % > batas ditolak, diskon > subtotal ditolak, bayar kurang ditolak, non-tunai wajib pas
- [ ] Commit atomik: insert transaksi + items (snapshot) + kurangi stok barang dalam 1 `transaction()`
- [ ] Sukses → dialog kembalian + tombol Lihat Struk PDF / Transaksi Baru
- **Acceptance:** 10 skenario bayar (pas, lebih, kurang, QRIS tanpa kembalian, diskon ganda + pajak) semua benar sesuai §1.

### FASE 3 — Riwayat Transaksi (1–2 hari)
- [ ] List + search + filter tanggal cepat + detail (item, diskon, pajak, kasir, pelanggan)
- [ ] Tombol cetak ulang PDF + Void (admin + konfirmasi + alasan wajib, simpan void_by/at)
- **Acceptance:** void mengembalikan stok barang (jasa tidak), laporan tidak hitung transaksi batal.

### FASE 4 — Laporan (2–3 hari)
- [ ] Filter: Hari ini / Minggu ini / Bulan ini / Tahun ini / Custom range (inclusive 00:00–23:59)
- [ ] KPI: omzet kotor, total diskon, pajak terkumpul, omzet bersih, jumlah transaksi, rata-rata struk
- [ ] Grafik `fl_chart` (batang harian) + produk terlaris + breakdown metode bayar
- [ ] Export PDF ringkasan + CSV detail
- **Acceptance:** data uji 30 transaksi acak → angka manual (Excel) sama dengan app untuk semua periode.

### FASE 5 — Struk PDF + Settings (1–2 hari)
- [ ] `receipt_pdf.dart`: header toko, tabel item, rincian diskon/pajak/total/bayar/kembalian, footer terima kasih
- [ ] Share + Print via `printing/share_plus`
- [ ] Settings: nama/alamat toko, pajak adjustable (**0–100%**), max diskon, ganti PIN, backup/restore file DB (copy sqlite)
- **Acceptance:** PDF terbuka di HP & tablet, nominal Rp benar, pajak tampil sesuai setting.

### FASE 6 — Hardening / Fulltest (2–3 hari)
- [ ] Unit: `calc_test` (≥20 kasus), `period_test` (minggu/bulan/kabisat/custom), `money_test`
- [ ] Widget: alur POS, validasi checkout, stok habis, produk nonaktif
- [ ] Integration: login → jual tunai → jual QRIS → cek riwayat → cek laporan → void → cek stok kembali
- [ ] Manual: HP kecil (5"), HP besar, tablet 7" & 10", portrait/landscape, font besar, 200 produk
- [ ] `flutter analyze`, `flutter test`, `flutter test integration_test` semua hijau
- **Acceptance (Definisi Selesai):** 0 error analyze, 0 test gagal, tidak ada crash pada checklist manual, APK release bisa di-install.

## 7. Perintah Penting

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test integration_test
flutter run -d <device_hp> && flutter run -d <device_tablet>
flutter build apk --release
```

## 8. Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| Salah hitung diskon+pajak | Satu-satunya logika di `calculate_total.dart` (domain POS) + unit test ketat |
| Filter laporan salah batas | `period.dart` inclusive + test kabisat & akhir bulan |
| DB korup / skema berubah | Drift versioned + backup/restore file |
| PDF Rp berantakan | Font bawaan pdf lib + test snapshot nominal |
| Stok minus saat balapan | Cek + update stok dalam 1 transaksi DB |

## 9. Definisi Selesai (DoD) Tiap Fase

1. Kode + test fase hijau, analyze bersih.
2. Dicoba di 1 HP + 1 tablet (atau emulator keduanya).
3. Acceptance fase tercentang.
4. Tidak ada TODO tanpa issue tercatat.

---
*Dokumen ini adalah acuan. Mulai dari FASE 0 → 6 berurutan. Jangan lompat ke POS sebelum calc + period + DB selesai dan dites.*
