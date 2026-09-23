# Devlog Fase 1 — Master: Produk, Pelanggan, User

> Acuan: `PLAN_IMPLEMENTATION.md` §6 Fase 1. Tanpa hapus permanen (hanya nonaktif).
> Aturan: PIN hash + lockout, guard kasir ❌ users/tax/void.

- [x] Data: `ProductRepositoryImpl` Drift (filter query/kategori, upsert, toggle aktif)
- [x] Data: `CustomerRepositoryImpl` Drift (search, upsert)
- [x] Data: `SettingsRepositoryImpl` Drift (get/save tax 0–100, save store)
- [x] Data: `UserRepositoryImpl` Drift (login hash + lockout device, CRUD, change PIN)
- [x] Domain: `save_customer.dart` terpisah + `create_user` + `change_pin` + `toggle_user_active`
- [x] Providers: produk, pelanggan, auth, users, settings
- [x] UI: Produk (list + search + filter kategori + form + toggle)
- [x] UI: Pelanggan (list + search + form)
- [x] UI: Users (list + tambah + toggle) + Login + Change PIN wajib
- [x] UI: Store + Tax (form sederhana, tax 0–100%)
- [x] Router: `/login`, `/change-pin`, redirect guard auth + role
- [x] Test: unit usecase + repo memory-DB (login/lockout, produk CRUD)
- [x] `flutter analyze` bersih + `flutter test` hijau
