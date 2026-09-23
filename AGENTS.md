# AGENTS.md — Kasirapp POS Dev Rules

## 1. Arsitektur

Full Clean Architecture seragam, feature-first: `domain / data / presentation`
per fitur. Aturan dependency: `presentation → domain ← data`.
Domain murni Dart — tanpa Flutter/Drift/Riverpod. Acuan: `PLAN_IMPLEMENTATION.md`.

## 2. Aturan Hitung

Satu-satunya logika hitung ada di
`lib/features/pos/domain/usecases/calculate_total.dart` (PLAN §1).
UI dilarang menghitung sendiri — wajib panggil usecase.

## 3. Devlog per Fase (WAJIB)

- Setiap akan mengeksekusi sebuah fase, buat file
  `devlog/fase-[nomor-fase].md` (contoh: `devlog/fase-0.md`).
- Format: checklist Markdown (`- [ ]` / `- [x]`).
- Setiap item rencana fase ditulis sebagai satu checkbox.
- Tandai `- [x]` segera setelah item selesai dikerjakan dan terverifikasi
  (analyze/test bila relevan) — jangan menunda centang ke akhir fase.
- Dilarang mengklaim fase selesai bila masih ada `- [ ]` tersisa.

## 4. Kualitas

- `flutter analyze` bersih dan `flutter test` hijau sebelum fase dinyatakan selesai.
- Validasi domain (stok jasa, batas diskon, uang pas non-tunai, alasan void,
  format PIN) tinggal di usecase, bukan di UI.
