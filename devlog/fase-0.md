# Devlog Fase 0 — Fondasi

> Acuan: `PLAN_IMPLEMENTATION.md` §6 Fase 0. Checklist dicentang saat item selesai + terverifikasi.

- [x] Dependensi batch 1 (`flutter_riverpod, go_router, intl, uuid, path, path_provider`) + `flutter pub get`
- [x] Dependensi batch 2 (`drift, sqlite3_flutter_libs` + dev `drift_dev, build_runner`) + `flutter pub get`
- [x] Dependensi batch 3 (`crypto, mocktail`) + `flutter pub get`
- [x] Drift DB v1 (`lib/data/db.dart` + tabel + index + `schemaVersion = 1`) + `build_runner build` sukses
- [x] Seed settings default + admin PIN `1234` hash + `must_change_pin=1`
- [x] Router 3-tab (`app.dart` + `router.dart`: Kasir, Riwayat, Setting + sub-routes + guard)
- [x] `main.dart` bootstrap (init DB → seed → ProviderScope, ganti counter template)
- [x] `flutter analyze` bersih + `flutter test` hijau
