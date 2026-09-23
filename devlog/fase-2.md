# Devlog Fase 2 — POS / Kasir (inti)

> Acuan: `PLAN_IMPLEMENTATION.md` §6 Fase 2 + §1 aturan hitung.
> UI dilarang menghitung — preview & checkout via domain.

- [x] Domain: `CartTotals` + `summarizeCart` sync (satu-satunya komputasi, dipakai preview + `CalculateTotal`)
- [x] Data: checkout atomik Drift (cek stok barang, insert snapshot, kurangi stok, 1 `transaction()`)
- [x] Providers: cart (tambah/kurang/qty/diskon line/struk/pelanggan), payment, preview totals
- [x] UI: grid menu aktif (HP 2 kol, tablet 3–4) + tambah ke keranjang + blokir stok habis
- [x] UI: panel keranjang (stepper qty, diskon per-line, diskon struk, pelanggan, preview pajak/total)
- [x] UI: checkout sheet (metode, nominal cepat, input bayar, kembalian live, validasi)
- [x] UI: dialog sukses (kembalian + transaksi baru)
- [x] Test: summarize + checkout repo memory-DB (stok kurang, jasa, non-tunai) + cart provider
- [x] `flutter analyze` bersih + `flutter test` hijau
