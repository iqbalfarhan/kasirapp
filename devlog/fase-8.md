# Fase 8 — Grid cols responsif saat resize (tetap 2-4)

- [x] Ganti bucket `w<400?2:w<700?3:4` jadi adaptif `(w/180).floor().clamp(2,4)` di `menu_grid.dart`
- [x] Tambah `ValueKey(cols)` di `Wrap` agar relayout saat bucket pindah
- [x] `flutter analyze` bersih dan `flutter test` hijau
