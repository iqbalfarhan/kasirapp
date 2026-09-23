# Devlog Fase 4 — Laporan

> Acuan: `PLAN_IMPLEMENTATION.md` §6 Fase 4. Hanya status sukses yang dihitung.
> Periode via `core/period.dart` (minggu = Senin–Minggu, custom inclusive).

- [x] Dep: `fl_chart` + `flutter pub get`
- [x] Domain: `ReportData` (summary + harian + terlaris + metode), usecase tetap `GetReport`
- [x] Data: agregasi Drift (exclude batal, bucket harian, top produk, breakdown metode)
- [x] Export: PDF ringkasan + CSV detail (builder murni, testable)
- [x] Providers: periode (hari/minggu/bulan/tahun/custom) + data laporan
- [x] UI: chips periode + kartu KPI + grafik batang + terlaris + metode + tombol export
- [x] Test: repo memory-DB (angka vs manual, void exclude, bucket, terlaris) + CSV builder
- [x] `flutter analyze` bersih + `flutter test` hijau
