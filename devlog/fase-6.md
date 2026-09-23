# Devlog Fase 6 — Hardening / Fulltest

> Acuan: `PLAN_IMPLEMENTATION.md` §6 Fase 6. DoD: analyze bersih, semua test hijau.

- [x] Unit: `calculate_total` ≥20 kasus (clamp, rounding, batas, uang pas)
- [x] Unit: `period` (hari/minggu/bulan/kabisat/custom) + `money` (format/parse)
- [x] Widget: login → change PIN → kasir guard
- [x] Widget: POS blokir stok habis + sembunyikan nonaktif
- [x] Integration: login → jual tunai → jual QRIS → riwayat → laporan → void → stok kembali
- [x] Checklist manual HP/tablet (untuk user: tidak bisa dijalankan di sini)
- [x] `flutter analyze` bersih + `flutter test` + integration hijau

## Catatan device (dijalankan user — tidak tersedia di sini)

- Integration: `flutter test integration_test` di emulator/HP (DB file asli,
  pakai dataset uji). File `integration_test/app_test.dart` sudah analyze-bersih.
- Manual: HP kecil 5", HP besar, tablet 7" & 10", portrait/landscape,
  font besar 1.3x, 200 produk scroll, rotasi saat checkout sheet terbuka,
  login salah 5x (lockout), ganti pajak lalu cek struk lama tidak berubah,
  backup lalu restore lalu restart.
- Release: `flutter build apk --release` lalu install & smoke test kasir.
