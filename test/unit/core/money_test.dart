import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/money.dart';

/// Format & parse IDR: "Rp 15.000", tanpa desimal.
void main() {
  group('formatRp', () {
    test('ribuan pakai titik', () {
      expect(formatRp(15000), 'Rp 15.000');
    });
    test('nol', () {
      expect(formatRp(0), 'Rp 0');
    });
    test('ratusan tanpa titik', () {
      expect(formatRp(500), 'Rp 500');
    });
    test('jutaan', () {
      expect(formatRp(2500000), 'Rp 2.500.000');
    });
    test('negatif', () {
      expect(formatRp(-5000), '- Rp 5.000');
    });
    test('satuan', () {
      expect(formatRp(7), 'Rp 7');
    });
  });

  group('parseRp', () {
    test('format standar', () {
      expect(parseRp('Rp 15.000'), 15000);
    });
    test('angka polos', () {
      expect(parseRp('25000'), 25000);
    });
    test('input field campur teks', () {
      expect(parseRp('Rp 2.500.000,-'), 2500000);
    });
    test('kosong = 0', () {
      expect(parseRp(''), 0);
      expect(parseRp('Rp'), 0);
    });
    test('roundtrip', () {
      for (final v in [0, 7, 500, 15000, 2500000, 11000]) {
        expect(parseRp(formatRp(v)), v);
      }
    });
  });
}
